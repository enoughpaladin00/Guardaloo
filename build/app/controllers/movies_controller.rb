# class MoviesController < ApplicationController
#   def show
#     @movie = Movie.find(params[:id])
#     @movie_details = TmdbService.new().fetch_movie_details(@movie.tmdb_id)
#   end
# end


# class MoviesController < ApplicationController
#   def search
#     query = params[:q]
#     results = TmdbService.search_movie_by_title(query)
#     render json: results.map { |m| { id: m["id"], title: m["title"], poster_path: m["poster_path"] } }
#   end
# end


class MoviesController < ApplicationController
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
