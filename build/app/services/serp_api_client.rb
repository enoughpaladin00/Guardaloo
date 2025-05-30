require "google_search_results"

class SerpApiClient
  API_KEY = ENV["SERP_API_KEY"]

  def self.search_cinema_programs(query: "Mission: Impossible showtime")
    params = {
      engine: "google",
      q: query,
      location: "Colleferro, Italy",
      hl: "it",
      gl: "it",
      serp_api_key: API_KEY
    }

    client = GoogleSearch.new(params)
    results = client.get_hash

    results[:showtimes] || []
  end
end
