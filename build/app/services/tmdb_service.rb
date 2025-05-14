require 'net/http'
require 'json'

class TmdbService
  BASE_URL = "https://api.themoviedb.org/3"

  def self.trending_movies
    url = URI("#{BASE_URL}/trending/movie/week?api_key=#{ENV['TMDB_API_KEY']}")
    response = Net::HTTP.get(url)
    JSON.parse(response)["results"]
  rescue => e
    Rails.logger.error "Errore TMDB: #{e.message}"
    []
  end
end
