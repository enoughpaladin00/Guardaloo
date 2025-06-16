class HomepageController < ApplicationController
    before_action :authenticate_user!
    def homepage
        @trending_movies = TmdbService.trending_movies
        @movie_details = @trending_movies.map do |movie|
        [ movie["id"], TmdbService.new.fetch_movie_details(movie["id"]) ]
        end.to_h
        @top_movies = TmdbService.top_10_streaming_movies
        @trending_series = TmdbService.trending_series
        @top_series = TmdbService.top_10_series
        @stream_movie = TmdbService.streaming_movies

        location_str = ""
        location = session[:user_location]&.symbolize_keys
        Rails.logger.info "SESSION LOCATION: #{location.inspect}"

        if location.present? && location[:lat].present? && location[:lng].present?
          city_data = Geocoder.search([ location[:lat], location[:lng] ]).first
          if city_data
            location_str = city_data.city || city_data.data["address"]["city"] || city_data.data["address"]["town"] || "Rome, Italy"
            Rails.logger.info "LOCATION SET (city): #{location_str}"
          else
            location_str = "Rome, Italy"
            Rails.logger.warn "FALLBACK: Geocoder non ha trovato città"
          end
        else
          location_str = "Rome, Italy"
          Rails.logger.warn "LOCATION FALLBACK TO DEFAULT: #{location_str}"
        end

        @cinemas = SerpApiClient.search_cinema("cinema", location_str)

        @cinemas_for_map = []

##        @cinemas[:places]&.each do |cinema_data|
##          cinema = Cinema.find_or_geocode({
##            id: cinema_data[:place_id],
##            name: cinema_data[:title],
##            address: cinema_data[:address],
##            lat: cinema_data[:gps_coordinates][:lat],
##            lng: cinema_data[:gps_coordinates][:lng]
##          })
##          
##        
##          if cinema&.geocoded?
##            Rails.logger.info "✔ Geocoded: #{cinema.name} (#{cinema.latitude}, #{cinema.longitude})"
##            @cinemas_for_map << {
##              id: cinema.id,
##              name: cinema.name,
##              address: cinema.address,
##              lat: cinema.latitude,
##              lng: cinema.longitude
##            }
##          else
##            Rails.logger.warn "⚠ Geocoding fallito per: #{cinema.name}"
##          end
##        end
    end
end
