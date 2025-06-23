require "net/http"

class SearchController < ApplicationController
  def tmdb
    query = params[:q].to_s
    return render plain: "" if query.blank?

    api_key = ENV["TMDB_API_KEY"]
    encoded_query = URI.encode_www_form_component(query)
    url = URI("https://api.themoviedb.org/3/search/multi?api_key=#{api_key}&language=it-IT&query=#{encoded_query}")

    response = Net::HTTP.get_response(url)

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)

      @results = data["results"]
        .select { |r| [ "movie", "tv" ].include?(r["media_type"]) }
        .sort_by do |r|
          date = r["release_date"] || r["first_air_date"]
          date.present? ? Date.parse(date) : Date.new(1900)
        end
        .reverse
    else
      @results = []
    end

    render partial: "search/results_tmdb", locals: { results: @results }
  end
end
