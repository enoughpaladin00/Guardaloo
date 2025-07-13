class MoviesController < ApplicationController
  before_action :authenticate_user!

  ALLOWED_PROVIDERS = [
    "Netflix",
    "Amazon Prime Video",
    "Disney Plus",
    "NOW TV"

  ].freeze

  PROVIDER_SEARCH_URLS = {
    "Netflix" => "https://www.netflix.com/search?q=",
    "Amazon Prime Video" => "https://www.primevideo.com/search/ref=atv_nb_sr?phrase=",
    "Disney Plus" => "https://www.disneyplus.com/search?q=",
    "NOW TV" => "https://nowtv.it/search?query="

  }.freeze

  def show
    @user = current_user
    tmdb_id = params[:tmdb_id]
    tmdb_type = params[:type] || "movie"
    @posts = Post.includes(:user, :comments).where(movie_id: params[:tmdb_id])
    @posts = @posts.sort_by(&:created_at).reverse

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
    @shown_providers = (@italian_providers["flatrate"] || []).select { |p| ALLOWED_PROVIDERS.include?(p["provider_name"]) }

    @all_italian_providers = service.fetch_italian_movie_providers(tmdb_type)["results"]
    @cleaned_providers = @all_italian_providers.map do |provider|
      provider.reject { |key, _| key == "display_priorities" }
    end

    @provider_links = @shown_providers.map do |provider|
      search_base = PROVIDER_SEARCH_URLS[provider["provider_name"]]
      if search_base
        { name: provider["provider_name"], logo: provider["logo_path"], url: "#{search_base}#{URI.encode_www_form_component(@movie_details['title'])}" }
      else
        { name: provider["provider_name"], logo: provider["logo_path"], url: @italian_providers["link"] }
      end
    end

    location = session[:user_location]&.symbolize_keys
    location_str = "Rome, Italy"

    if location.present? && location[:lat].present? && location[:lng].present?
      city_data = Geocoder.search([ location[:lat], location[:lng] ]).first

      if city_data
        location_str = city_data.city ||
                       city_data.data.dig("address", "city") ||
                       city_data.data.dig("address", "town") ||
                       city_data.data.dig("address", "county") ||
                       city_data.state ||
                       city_data.data.dig("address", "state") ||
                       city_data.country ||
                       "Rome, Italy"

        Rails.logger.info "Location risolta: #{location_str}"
      else
        Rails.logger.warn "Geocoder non ha trovato location. Fallback su Roma."
      end
    else
      Rails.logger.warn "Location assente in sessione. Fallback su Roma."
    end

    @showtimes_array = SerpApiClient.search_cinema_programs("#{@movie_details['title']} showtimes", location_str).map(&:deep_symbolize_keys)
    @days = []
    @cinemas_by_day = []
    @cinemas_by_day_hash = {}
    @showtimes_array.each do |showtimes|
      day_string = showtimes[:day]
      if day_string =~ /([A-Za-z]+)(\d{1,2})\s(\w{3})/
        abbrev_day = $1
        day_number = $2.to_i
        abbrev_month = $3
        full_day = GIORNI_SETTIMANA[abbrev_day] || abbrev_day
        full_month = MESI[abbrev_month] || abbrev_month
        day = "#{full_day} #{day_number} #{full_month}"
      else
        day = day_string
      end
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
    @vote_average = @movie_details["vote_average"]
    @stars = (@vote_average / 2.0).round(1)

    @credits = service.fetch_movie_credits(tmdb_id, tmdb_type)
    @director = @credits["crew"]&.find do |person|
      [ "Director", "Creator", "Executive Producer", "Series Director" ].include?(person["job"])
    end&.dig("name")

    @videos = service.fetch_movie_videos(tmdb_id, tmdb_type)
    @trailer = @videos["results"].find { |v| v["type"] == "Trailer" && v["site"] == "YouTube" }
  end

  def search
    query = params[:query].to_s.strip
    results = TmdbService.search_movie_by_title(query)

    render json: results.map { |movie|
      {
        title: movie["title"],
        id: movie["id"],
        release_date: movie["release_date"],
        poster_path: movie["poster_path"]
      }
    }
  end
end
