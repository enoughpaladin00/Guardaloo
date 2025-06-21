class CinemasController < ApplicationController
  def index
    cinemas = Cinemasdef.all.map do |cinema|
      {
        id: cinema.id,
        name: cinema.name,
        address: cinema.address,
        town: cinema.town,
        province: cinema.province,
        phone: cinema.phone,
        lat: cinema.lat.to_f,
        lon: cinema.lon.to_f
      }
    end

    if params[:lat].present? && params[:lon].present?
      user_lat = params[:lat].to_f
      user_lon = params[:lon].to_f

      cinemas = cinemas.map do |cinema|
        if cinema[:lat].nonzero? && cinema[:lon].nonzero?
          distance = distance_km(user_lat, user_lon, cinema[:lat], cinema[:lon])
          if distance < 10.0
            cinema.merge(distance: distance.round(2))
          else
            nil
          end
        else
          nil
        end
      end.compact.sort_by { |c| c[:distance] }
    end

    respond_to do |format|
      format.html { @cinemas = cinemas }
      format.json { render json: cinemas }
    end
  end

  private

  def distance_km(lat1, lon1, lat2, lon2)
    rad_per_deg = Math::PI / 180
    r_km = 6371

    dlat_rad = (lat2 - lat1) * rad_per_deg
    dlon_rad = (lon2 - lon1) * rad_per_deg

    lat1_rad = lat1 * rad_per_deg
    lat2_rad = lat2 * rad_per_deg

    a = Math.sin(dlat_rad / 2)**2 +
        Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad / 2)**2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    r_km * c
  end
end
