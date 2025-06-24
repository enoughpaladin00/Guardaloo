# app/controllers/cinemas_controller.rb
# app/controllers/cinemas_controller.rb
class CinemasController < ApplicationController
  # Assicurati di avere un modello corrispondente alla tua tabella `cinemasdef`.
  # Userò `Cinemasdef` come da te specificato.
  
  def index
    # Recupera tutti i cinema dalla tua tabella `cinemasdef`
    all_cinemas = Cinemasdef.all 
    
    if params[:lat].present? && params[:lon].present?
      user_lat = params[:lat].to_f
      user_lon = params[:lon].to_f
      user_city = params[:user_city] # Città rilevata dal frontend
      user_province = params[:user_province] # Provincia rilevata dal frontend

      cinemas_in_range = all_cinemas.map do |cinema|
        cinema_lat = cinema.lat.to_f rescue nil # Usa cinema.lat come da tua tabella
        cinema_lon = cinema.lon.to_f rescue nil # Usa cinema.lon come da tua tabella
        
        if cinema_lat && cinema_lon
          distance = distance_km(user_lat, user_lon, cinema_lat, cinema_lon)
          if distance < 10.0 # Filtra entro 10 km
            # Restituisci un hash con i dati del cinema, inclusa la distanza
            {
              id: cinema.id,
              name: cinema.name,
              address: cinema.address,
              town: cinema.town,
              province: cinema.province,
              phone: cinema.phone,
              distance: distance.round(2)
            }
          else
            nil
          end
        else
          nil # Cinema senza coordinate valide
        end
      end.compact.sort_by { |c| c[:distance] } # Rimuovi i nil e ordina per distanza
    else
      # Se la geolocalizzazione non è disponibile, restituisci un array vuoto o tutti i cinema
      cinemas_in_range = [] 
    end

    respond_to do |format|
      format.html { @cinemas = cinemas_in_range }
      format.json { render json: cinemas_in_range }
    end
  end

  # Azione per la programmazione del cinema (chiamata via AJAX)
  def programmazione
    cinema_name = params[:cinema_name]
    cinema_town = params[:cinema_town]
    cinema_province = params[:cinema_province]
    cinema_country = params[:cinema_country]

    if cinema_name.blank? || cinema_town.blank? || cinema_country.blank?
      render json: { error: "Nome cinema, città o paese mancanti per la ricerca della programmazione" }, status: :bad_request
      return
    end

    # Costruisci la stringa location per SerpAPI
    location_for_serpapi = [cinema_town, cinema_province, cinema_country].compact.join(', ')
    
    begin
      # Chiama il tuo NUOVO servizio CinemaShowtimesService
      programmazione_data = CinemaShowtimesService.fetch_showtimes(cinema_name, location_for_serpapi)
      
      render json: programmazione_data
    rescue StandardError => e
      Rails.logger.error "Errore nel recupero della programmazione da CinemaShowtimesService per '#{cinema_name}' in '#{location_for_serpapi}': #{e.message}"
      render json: { error: "Impossibile recuperare la programmazione. Riprova più tardi." }, status: :internal_server_error
    end
  end

  private

  # Funzione helper per calcolare la distanza tra due punti geografici in km
  def distance_km(lat1, lon1, lat2, lon2)
    rad_per_deg = Math::PI / 180
    r_km = 6371 # Raggio medio della Terra in chilometri

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