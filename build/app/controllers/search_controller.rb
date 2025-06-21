require "net/http"
require "uri"
require "json"

class SearchController < ApplicationController
  def tmdb
    query = params[:query]
    return render json: { error: "Query mancante" }, status: :bad_request if query.blank?

    api_key = ENV["TMDB_API_KEY"] || "INSERISCI_LA_TUA_API_KEY"

    url = URI("https://api.themoviedb.org/3/search/multi?api_key=#{api_key}&language=it-IT&query=#{URI.encode_www_form_component(query)}")
    response = Net::HTTP.get_response(url)

    if response.is_a?(Net::HTTPSuccess)
      json_data = JSON.parse(response.body)
      render json: json_data
    else
      render json: { error: "Errore da TMDB: #{response.code}" }, status: :bad_gateway
    end
  end
end
