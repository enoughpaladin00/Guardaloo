class CinemasController < ApplicationController
  before_action :authenticate_user!
  require "httparty"

  def index
    @user = current_user
    all_cinemas = Cinemasdef.all
    cinemas_to_render = []
    search_range = params[:range].present? ? params[:range].to_f : 10.0
    search_range = 10.0 if search_range <= 0

    if params[:favorites_only].present? && params[:favorites_only] == "true"
      if current_user
        favorited_cinema_ids = current_user.favorite_cinemas_list.pluck(:id)
        cinemas_to_render = all_cinemas.select { |cinema| favorited_cinema_ids.include?(cinema.id) }.map do |cinema|
          {
            id: cinema.id,
            name: cinema.name,
            address: cinema.address,
            town: cinema.town,
            province: cinema.province,
            phone: cinema.phone,
            distance: nil,
            is_favorited: true
          }
        end.compact.sort_by { |c| c[:name] }
      else
        cinemas_to_render = []
      end
    elsif params[:city].present?
      city_name = params[:city].strip
      filtered_cinemas_by_city = all_cinemas.where("lower(town) = ?", city_name.downcase)
      cinemas_to_render = filtered_cinemas_by_city.map do |cinema|
        is_favorited = current_user ? current_user.favorite_cinemas_list.include?(cinema) : false
        {
          id: cinema.id,
          name: cinema.name,
          address: cinema.address,
          town: cinema.town,
          province: cinema.province,
          phone: cinema.phone,
          distance: nil,
          is_favorited: is_favorited
        }
      end.compact.sort_by { |c| c[:name] }

    elsif params[:lat].present? && params[:lon].present?
      user_lat = params[:lat].to_f
      user_lon = params[:lon].to_f

      user_city = "Sconosciuta"
      user_province = "Sconosciuta"
      user_country = "Italy"

      begin
        nominatim_url = "https://nominatim.openstreetmap.org/reverse?format=json&lat=#{user_lat}&lon=#{user_lon}"
        nominatim_response = HTTParty.get(nominatim_url, headers: { "User-Agent" => "GuardalooApp/1.0 (guardaloo@example.com)" })
        if nominatim_response.success?
          geocode_data = nominatim_response.parsed_response
          user_city = geocode_data["address"]["city"] || geocode_data["address"]["town"] || geocode_data["address"]["village"] || "Frosinone"
          user_province = geocode_data["address"]["state"] || "Lazio"
          user_country = geocode_data["address"]["country"] || "Italy"
        else
          Rails.logger.error "Errore HTTP da Nominatim: #{nominatim_response.code} - #{nominatim_response.body}"
        end
      rescue HTTParty::Error => e
        Rails.logger.error "Errore di rete con HTTParty per Nominatim: #{e.message}"
      rescue JSON::ParserError => e
        Rails.logger.error "Errore di parsing JSON da Nominatim: #{e.message}. Risposta ricevuta: #{nominatim_response.body}"
      rescue StandardError => e
        Rails.logger.error "Errore sconosciuto nella geocodifica inversa: #{e.message}"
      end


      favorited_cinema_ids = current_user ? current_user.favorite_cinemas_list.pluck(:id) : []
      cinemas_to_render = all_cinemas.map do |cinema|
        cinema_lat = cinema.lat.to_f rescue nil
        cinema_lon = cinema.lon.to_f rescue nil

        if cinema_lat && cinema_lon
          distance = distance_km(user_lat, user_lon, cinema_lat, cinema_lon)
          is_favorited = favorited_cinema_ids.include?(cinema.id)
          if distance <= search_range
            {
              id: cinema.id,
              name: cinema.name,
              address: cinema.address,
              town: cinema.town,
              province: cinema.province,
              phone: cinema.phone,
              distance: distance.round(2),
              is_favorited: is_favorited
            }
          else
            nil
          end
        else
          nil
        end
      end.compact.sort_by { |c| c[:distance] }
    else
      cinemas_to_render = []
    end

    respond_to do |format|
      format.html { @cinemas = cinemas_to_render }
      format.json { render json: cinemas_to_render }
    end
  end

  def programmazione
    cinema_name = params[:cinema_name]
    cinema_town = params[:cinema_town] || "Frosinone"
    cinema_province = params[:cinema_province] || "Lazio"
    cinema_country = params[:cinema_country] || "Italy"

    if cinema_name.blank?
      render json: { error: "Nome cinema mancante per la ricerca della programmazione" }, status: :bad_request
      return
    end

    location_for_serpapi = [ cinema_town, cinema_province, cinema_country ].compact.join(", ")

    begin
      programmazione_data = CinemaShowtimesService.fetch_showtimes(cinema_name, location_for_serpapi)
      render json: programmazione_data
    rescue StandardError => e
      Rails.logger.error "Errore nel recupero della programmazione da CinemaShowtimesService per '#{cinema_name}' in '#{location_for_serpapi}': #{e.message}"
      render json: { error: "Impossibile recuperare la programmazione. Riprova più tardi." }, status: :internal_server_error
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
