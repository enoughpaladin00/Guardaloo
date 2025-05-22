class MoviesController < ApplicationController
  def show
    @movie = Movie.find(params[:id])
    @movie_details = TmdbService.new().fetch_movie_details(@movie.tmdb_id)
  end
end
