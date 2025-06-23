class HomepageController < ApplicationController
    before_action :authenticate_user!
    def homepage
      @trending_movies = TmdbService.trending_movies
      @movie_details = @trending_movies.map do |movie|
      [ movie["id"], TmdbService.new.fetch_movie_details(movie["id"], "movie") ]
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

        @cinemas = find_nearby_cinemas(location[:lat], location[:lng], 50)
      else
        location_str = "Rome, Italy"
        Rails.logger.warn "LOCATION FALLBACK TO DEFAULT: #{location_str}"

        @cinemas = find_nearby_cinemas(41.9028, 12.4964, 20)
      end
      @cinemas_for_map = []
      @cinemas_for_map = @cinemas.map do |cinema|
        {
          id: cinema.id,
          name: cinema.name,
          address: cinema.respond_to?(:address) ? cinema.address : "Indirizzo non disponibile",
          lat: cinema.lat,
          lng: cinema.lon
        }
      end
    end

    private

    def find_nearby_cinemas(lat, lng, radius_km)
      Cinemasdef
        .select(
          Cinemasdef.arel_table[Arel.star],
          Arel.sql(%(
            6371 * acos(
              cos(radians(#{lat})) *
              cos(radians(lat)) *
              cos(radians(lon) - radians(#{lng})) +
              sin(radians(#{lat})) *
              sin(radians(lat))
            ) AS distance
          ))
        )
        .where(
          Arel.sql(%(
            6371 * acos(
              cos(radians(#{lat})) *
              cos(radians(lat)) *
              cos(radians(lon) - radians(#{lng})) +
              sin(radians(#{lat})) *
              sin(radians(lat))
            ) < #{radius_km}
          ))
        )
        .order(Arel.sql("distance"))
        .limit(20)
    end
end
