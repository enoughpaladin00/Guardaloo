require "net/http"
require "uri"
require "json"

class SearchController < ApplicationController
  def tmdb
    query = params[:q].to_s
    return render json: [] if query.blank?

    url = URI("https://api.themoviedb.org/3/search/movie?query=#{URI.encode_www_form_component(query)}&api_key=#{ENV['TMDB_API_KEY']}&language=it-IT")
    response = Net::HTTP.get(url)
    results = JSON.parse(response)["results"]&.first(5) || []

    render json: results.map { |movie|
      {
        tmdb_id: movie["id"],
        title: movie["title"],
        year: movie["release_date"]&.first(4),
        poster_url: movie["poster_path"] ? "https://image.tmdb.org/t/p/w185#{movie["poster_path"]}" : "/placeholder_poster.png"
      }
    }
  end
end
