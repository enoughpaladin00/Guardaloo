require "net/http"
require "json"

class TmdbService
  BASE_URL = "https://api.themoviedb.org/3"
  API_KEY = ENV["TMDB_API_KEY"]

  def fetch_movie_details(tmdb_id, type)
    url = URI("#{BASE_URL}/#{type}/#{tmdb_id}?api_key=#{API_KEY}&language=it-IT")
    response = Net::HTTP.get(url)
    JSON.parse(response)
  rescue StandardError => e
    Rails.logger.error("Errore TMDb API: #{e.message}")
    nil
  end

  def fetch_movie_watch_providers(tmdb_id, type)
    url = URI("https://api.themoviedb.org/3/#{type}/#{tmdb_id}/watch/providers?api_key=#{API_KEY}")
    response = Net::HTTP.get(url)
    JSON.parse(response)
  end

  def fetch_italian_movie_providers(type)
    url = URI("https://api.themoviedb.org/3/watch/providers/#{type}?api_key=#{ENV['TMDB_API_KEY']}&watch_region=IT")
    response = Net::HTTP.get(url)
    JSON.parse(response)
  end


  def fetch_movie_credits(tmdb_id, type)
    url = URI("https://api.themoviedb.org/3/#{type}/#{tmdb_id}/credits?api_key=#{API_KEY}&language=it-IT")
    response = Net::HTTP.get(url)
    JSON.parse(response)
  end

  def fetch_movie_videos(tmdb_id, type)
    url = URI("https://api.themoviedb.org/3/#{type}/#{tmdb_id}/videos?api_key=#{API_KEY}&language=it-IT")
    response = Net::HTTP.get(url)
    JSON.parse(response)
  end

  def self.trending_movies
    url = URI("#{BASE_URL}/trending/movie/week?api_key=#{API_KEY}&language=it-IT")
    response = Net::HTTP.get(url)
    JSON.parse(response)["results"]
  rescue => e
    Rails.logger.error "Errore TMDB: #{e.message}"
    []
  end

  def self.trending_series
    url = URI("#{BASE_URL}/trending/tv/week?api_key=#{API_KEY}&language=it-IT")
    response = Net::HTTP.get(url)
    JSON.parse(response)["results"]
  rescue => e
    Rails.logger.error "Errore TMDB: #{e.message}"
    []
  end

  def self.top_10_movies
    url = URI("#{BASE_URL}/movie/popular?api_key=#{API_KEY}&language=it-IT&watch_region=IT&page=1")
    response = Net::HTTP.get(url)
    parsed = JSON.parse(response)
    parsed["results"].first(10)
  rescue => e
    Rails.logger.error "Errore TMDB (top_10_movies): #{e.message}"
    []
  end

  def self.top_10_series
    url = URI("#{BASE_URL}/tv/popular?api_key=#{API_KEY}&language=it-IT&watch_region=IT&page=1")
    response = Net::HTTP.get(url)
    parsed = JSON.parse(response)
    parsed["results"].first(10)
  rescue => e
    Rails.logger.error "Errore TMDB (top_10_series): #{e.message}"
    []
  end

  def self.streaming_movies
    url = URI("#{BASE_URL}/discover/movie?api_key=#{API_KEY}&language=it-IT&watch_region=IT&with_watch_monetization_types=flatrate&sort_by=popularity.desc")
    response = Net::HTTP.get(url)
    parsed = JSON.parse(response)
    parsed["results"]
  rescue => e
    Rails.logger.error "Errore TMDB (streaming_movies): #{e.message}"
    []
  end

  def self.top_10_streaming_movies
    url = URI("#{BASE_URL}/discover/movie?api_key=#{API_KEY}&language=it-IT&watch_region=IT&with_watch_monetization_types=flatrate&sort_by=popularity.desc&page=1")
    response = Net::HTTP.get(url)
    parsed = JSON.parse(response)
    parsed["results"].first(10)
  rescue => e
    Rails.logger.error "Errore TMDB (top_10_streaming_movies): #{e.message}"
    []
  end
end
