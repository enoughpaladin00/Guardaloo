class MoviesController < ApplicationController
  def show
    tmdb_id = params[:tmdb_id]
    api_key = ENV['TMDB_API_KEY']

    url = "https://api.themoviedb.org/3/movie/#{tmdb_id}"
    response = HTTParty.get(url, query: { api_key: api_key, language: 'it-IT' })

    if response.success?
      @movie = response.parsed_response
    else
      render plain: "Film non trovato", status: :not_found
      return
    end

    service = TmdbService.new
    @movie_details = service.fetch_movie_details(tmdb_id)
    @cinemas = nil # o quelli che vuoi

    @providers = service.fetch_movie_watch_providers(tmdb_id)
    @italian_providers = @providers["results"]["IT"] || {}
    @allowed_providers = [
      "Netflix", "Disney Plus", "Amazon Prime Video", "Rakuten TV", "Apple TV", "Apple TV+",
      "Sky Go", "Google Play Movies", "Paramount Plus", "Now TV", "Mediaset Infinity", "MUBI",
      "Timvision", "Infinity+", "Rai Play", "Nexo Plus", "GuideDoc", "YouTube Premium", "Microsoft Store"
    ]

    @all_italian_providers = service.fetch_italian_movie_providers["results"]
    @cleaned_providers = @all_italian_providers.map do |provider|
      provider.reject { |key, _| key == "display_priorities" }
    end

    @credits = service.fetch_movie_credits(tmdb_id)
    @director = @credits["crew"].find { |person| person["job"] == "Director" }&.dig("name")

    @videos = service.fetch_movie_videos(tmdb_id)
    @trailer = @videos["results"].find { |v| v["type"] == "Trailer" && v["site"] == "YouTube" }
  end
end
