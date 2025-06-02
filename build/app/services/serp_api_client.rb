require "google_search_results"
require "net/http"
require "json"
require "uri"

class SerpApiClient
  API_KEY = ENV["SERP_API_KEY"]

  def self.search_cinema_programs(query, location)
    params = {
      engine: "google",
      q: query,
      location: location,
      hl: "it",
      gl: "it",
      serp_api_key: API_KEY
    }

    client = GoogleSearch.new(params)
    results = client.get_hash

    results[:showtimes] || []
  end


  def self.search_cinema(query, location)
    params = {
      engine: "google",
      q: query,
      location: location,
      hl: "it",
      gl: "it",
      serp_api_key: API_KEY
    }

    client = GoogleSearch.new(params)
    results = client.get_hash

    results[:local_results] || []
  end
end
