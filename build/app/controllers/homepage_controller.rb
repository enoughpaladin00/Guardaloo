class HomepageController < ApplicationController
    def homepage
        @trending_movies = TmdbService.trending_movies
        @movie_details = @trending_movies.map do |movie|
        [movie["id"], TmdbService.new.fetch_movie_details(movie["id"])]
        end.to_h
        @top_movies = TmdbService.top_10_movies
        @trending_series = TmdbService.trending_series
    end
end
