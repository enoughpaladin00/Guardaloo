require "google_search_results"
require "json"
require "uri"

class CinemaShowtimesService
  API_KEY = ENV["SERP_API_KEY"]

  def self.fetch_showtimes(cinema_name, location)
    return [] unless API_KEY.present?

    params = {
      engine: "google",
      q: "#{cinema_name} #{location} orari film",
      location: location,
      hl: "it",
      gl: "it",
      api_key: API_KEY
    }

    client = GoogleSearch.new(params)
    results = client.get_hash.deep_symbolize_keys

    Rails.logger.info "SerpAPI Movies Search for '#{cinema_name}' in '#{location}' - Raw Response: #{results.inspect}"

    programmazione = []

    if results[:showtimes].present? # Se c'è la chiave "showtimes" principale
      results[:showtimes].each do |day_data| # Itera sui dati di ogni giorno (es. "Oggi")
        if day_data[:movies].present? # Se ci sono film per quel giorno
          day_data[:movies].each do |movie| # Itera su ogni film
            if movie[:name].present? && movie[:showing].present? && movie[:showing].first && movie[:showing].first[:time].present?

              times = movie[:showing].first[:time].compact.flatten.uniq.sort

              programmazione << {
                title: movie[:name],
                showtimes: times
              }
            end
          end
        end
      end
    end

    programmazione.uniq { |p| p[:title] }
  rescue StandardError => e
    Rails.logger.error "Errore in CinemaShowtimesService durante la chiamata a SerpAPI per '#{cinema_name}' in '#{location}': #{e.message}"
    []
  end
end
