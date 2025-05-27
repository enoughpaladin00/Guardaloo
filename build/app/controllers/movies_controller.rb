class MoviesController < ApplicationController
  def show
    @movie = Movie.find_by!(tmdb_id: params[:tmdb_id])
    @movie_details = TmdbService.new().fetch_movie_details(@movie.tmdb_id)
    @cinemas = nil#@movie.cinemas.select(:name, :lat, :lng)

    @credits = TmdbService.new().fetch_movie_credits(@movie.tmdb_id)
    @director = @credits["crew"].find { |person| person["job"] == "Director" }&.dig("name")

    @videos = TmdbService.new.fetch_movie_videos(@movie.tmdb_id)
    @trailer = @videos["results"].find { |v| v["type"] == "Trailer" && v["site"] == "YouTube" }

  end
end
