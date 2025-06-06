class HomepageController < ApplicationController
    before_action :authenticate_user!
    def homepage
        @trending_movies = TmdbService.trending_movies
        @movie_details = @trending_movies.map do |movie|
        [ movie["id"], TmdbService.new.fetch_movie_details(movie["id"]) ]
        end.to_h
        @top_movies = TmdbService.top_10_streaming_movies
        @trending_series = TmdbService.trending_series
        @top_series = TmdbService.top_10_series
        @stream_movie = TmdbService.streaming_movies
    end
end
