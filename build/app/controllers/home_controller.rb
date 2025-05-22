class HomeController < ApplicationController
  def index
    @trending_movies = TmdbService.trending_movies
  end
end
