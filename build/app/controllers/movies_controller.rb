class MoviesController < ApplicationController
  def show
    @movie = Movie.find_by!(tmdb_id: params[:tmdb_id])
    @movie_details = TmdbService.new().fetch_movie_details(@movie.tmdb_id)
    @cinemas = nil#@movie.cinemas.select(:name, :lat, :lng)

    @providers = TmdbService.new.fetch_movie_watch_providers(@movie.tmdb_id)
    @italian_providers = @providers["results"]["IT"] || {}
    @allowed_providers = ["Netflix", "Disney Plus", "Amazon Prime Video", "Rakuten TV", "Apple TV", "Apple TV+", "Sky Go", "Google Play Movies", "Paramount Plus", "Now TV", "Mediaset Infinity", "MUBI", "Timvision", "Infinity+", "Rai Play", "Nexo Plus", "GuideDoc", "YouTube Premium", "Microsoft Store"]


    @all_italian_providers = TmdbService.new.fetch_italian_movie_providers["results"]
    @cleaned_providers = @all_italian_providers.map do |provider|
      provider.reject { |key, _| key == "display_priorities" }
    end


    @credits = TmdbService.new().fetch_movie_credits(@movie.tmdb_id)
    @director = @credits["crew"].find { |person| person["job"] == "Director" }&.dig("name")

    @videos = TmdbService.new.fetch_movie_videos(@movie.tmdb_id)
    @trailer = @videos["results"].find { |v| v["type"] == "Trailer" && v["site"] == "YouTube" }

  end
end
