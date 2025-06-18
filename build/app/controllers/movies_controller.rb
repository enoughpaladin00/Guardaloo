class MoviesController < ApplicationController
  before_action :authenticate_user!
  def show
    tmdb_id = params[:tmdb_id]
    tmdb_type = params[:type] || "movie"  # default "movie", oppure "tv"

    api_key = ENV["TMDB_API_KEY"]
    @map_id = ENV["GOOGLE_MAPS_ID"]

    url = "https://api.themoviedb.org/3/#{tmdb_type}/#{tmdb_id}"
    response = HTTParty.get(url, query: { api_key: api_key, language: "it-IT" })

    if response.success?
      @movie = response.parsed_response
    else
      render plain: "#{tmdb_type.capitalize} non trovato", status: :not_found
      return
    end

    service = TmdbService.new
    @movie_details = service.fetch_movie_details(tmdb_id, tmdb_type)

    @providers = service.fetch_movie_watch_providers(tmdb_id, tmdb_type)
    @italian_providers = @providers["results"]["IT"] || {}
    @allowed_providers = [
      "Netflix", "Disney Plus", "Amazon Prime Video", "Rakuten TV", "Apple TV", "Apple TV+",
      "Sky Go", "Google Play Movies", "Paramount Plus", "Now TV", "Mediaset Infinity", "MUBI",
      "Timvision", "Infinity+", "Rai Play", "Nexo Plus", "GuideDoc", "YouTube Premium", "Microsoft Store"
    ]

    @all_italian_providers = service.fetch_italian_movie_providers(tmdb_type)["results"]
    @cleaned_providers = @all_italian_providers.map do |provider|
      provider.reject { |key, _| key == "display_priorities" }
    end

    location_str = ""
    location = session[:user_location]&.symbolize_keys
    Rails.logger.info "SESSION LOCATION: #{location.inspect}"

    if location.present? && location[:lat].present? && location[:lng].present?
      city_data = Geocoder.search([ location[:lat], location[:lng] ]).first
      if city_data
        location_str = city_data.city || city_data.data["address"]["city"] || city_data.data["address"]["town"] || "Rome, Italy"
        Rails.logger.info "LOCATION SET (city): #{location_str}"
      else
        location_str = "Rome, Italy"
        Rails.logger.warn "FALLBACK: Geocoder non ha trovato città"
      end
    else
      location_str = "Rome, Italy"
      Rails.logger.warn "LOCATION FALLBACK TO DEFAULT: #{location_str}"
    end

    @showtimes_array = SerpApiClient.search_cinema_programs("#{@movie_details['title']} showtimes", location_str).map(&:deep_symbolize_keys)
    @days = []
    @cinemas_by_day = []
    @cinemas_by_day_hash = {}
    @showtimes_array.each do |showtimes|
      day = showtimes[:day]
      cinema = showtimes[:theaters] || []
      @days << day
      @cinemas_by_day << cinema
      @cinemas_by_day_hash[day] = cinema
    end
    @cinemas_for_map = []

    @cinemas_by_day.each do |cinemas|
      next if cinemas.nil?
      cinemas.each do |cinema_data|
        cinema = Cinema.find_or_geocode({
          name: cinema_data[:name],
          address: cinema_data[:address]
        })

        if cinema&.geocoded?
          @cinemas_for_map << {
            id: cinema.id,
            name: cinema.name,
            address: cinema.address,
            lat: cinema.latitude,
            lng: cinema.longitude,
            showing: cinema_data[:showing].first[:time].join(", ")
          }
        end
      end
    end

    @credits = service.fetch_movie_credits(tmdb_id, tmdb_type)
    @director = @credits["crew"]&.find do |person|
      [ "Director", "Creator", "Executive Producer", "Series Director" ].include?(person["job"])
    end&.dig("name")

    @videos = service.fetch_movie_videos(tmdb_id, tmdb_type)
    @trailer = @videos["results"].find { |v| v["type"] == "Trailer" && v["site"] == "YouTube" }
  end
end
