require 'net/http'
require 'json'

class TmdbService
  BASE_URL = "https://api.themoviedb.org/3"
  API_KEY = ENV["TMDB_API_KEY"]

  def fetch_movie_details(tmdb_id)
    url = URI("#{BASE_URL}/movie/#{tmdb_id}?api_key=#{API_KEY}&language=it-IT")
    response = Net::HTTP.get(url)
    JSON.parse(response)
  rescue StandardError => e
    Rails.logger.error("Errore TMDb API: #{e.message}")
    nil
  end

  def self.trending_movies
    url = URI("#{BASE_URL}/trending/movie/week?api_key=#{ENV['TMDB_API_KEY']}&language=it-IT")
    response = Net::HTTP.get(url)
    JSON.parse(response)["results"]
  rescue => e
    Rails.logger.error "Errore TMDB: #{e.message}"
    []
  end

  def self.trending_series
    url = URI("#{BASE_URL}/trending/tv/week?api_key=#{ENV['TMDB_API_KEY']}")
    response = Net::HTTP.get(url)
    JSON.parse(response)["results"]
  rescue => e
    Rails.logger.error "Errore TMDB: #{e.message}"
    []
  end

  def self.top_10_movies
    url = URI("#{BASE_URL}/movie/popular?api_key=#{API_KEY}&language=it-IT&page=1")
    response = Net::HTTP.get(url)
    parsed = JSON.parse(response)
    parsed["results"].first(10)
  rescue => e
    Rails.logger.error "Errore TMDB (top_10_movies): #{e.message}"
    []
  end
  
end
