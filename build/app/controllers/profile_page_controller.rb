class ProfilePageController < ApplicationController
  before_action :authenticate_user!
  before_action :require_login
  before_action :set_user

  def profile_index

    # Prendi gli ultimi 10 tmdb_id dai preferiti dell'utente
    bookmark_tmdb_ids = @user.bookmarks.order(created_at: :desc).limit(10).pluck(:tmdb_id)

    # Usa il TmdbService esistente - stessa logica di @trending_movies
    @preferiti = bookmark_tmdb_ids.filter_map do |tmdb_id|
      TmdbService.new.fetch_movie_details(tmdb_id, "movie")
    rescue => e
      Rails.logger.error "Errore nel recuperare il film #{tmdb_id}: #{e.message}"
      nil
    end

    # Film scelti dall'utente (fissi sul profilo) - usa TmdbService.get_movie
    @chosen_movies = []
    [@user.tmdb_fav1, @user.tmdb_fav2, @user.tmdb_fav3].each do |tmdb_id|
      if tmdb_id.present?
        movie = TmdbService.get_movie(tmdb_id)
        @chosen_movies << movie
      else
        @chosen_movies << nil
      end
    end
  end

  # Metodo per cercare film su TMDB
  def search_movies
   query = params[:query]
   return render json: [] if query.blank?

   results = TmdbService.search_movie_by_title(query)

   render json: results
  rescue => e
   Rails.logger.error "Errore nella ricerca film: #{e.message}"
   render json: []
  end

  # Metodo per aggiornare un film della Top 3
  def update_movie
    position = params[:position].to_i
    tmdb_id = params[:selected_movie_tmdb_id] # questo deve essere l'ID TMDB del film

    if tmdb_id.blank? || position < 1 || position > 3
      render json: { error: "Parametri mancanti o non validi" }, status: :bad_request
      return
    end

    begin
      case position
      when 1
        @user.update!(tmdb_fav1: tmdb_id)
      when 2
        @user.update!(tmdb_fav2: tmdb_id)
      when 3
        @user.update!(tmdb_fav3: tmdb_id)
      end

      render json: { message: "Film aggiornato con successo!" }, status: :ok
    rescue => e
      Rails.logger.error "Errore nell'aggiornamento: #{e.message}"
      render json: { error: "Errore nell'aggiornamento del film" }, status: :unprocessable_entity
    end
  end

  def movie_search
   query = params[:q].to_s.strip

   if query.blank? || query.length < 2
     return render json: { results: [], message: "Inserisci almeno 2 caratteri" }
   end

   begin
     results = fetch_movies_from_tmdb(query)
     render json: { results: results, message: results.empty? ? "Nessun film trovato" : nil }
   rescue => e
     Rails.logger.error "Errore ricerca TMDB: #{e.message}"
     render json: { results: [], message: "Errore durante la ricerca" }
   end
  end
  def fetch_movies_from_tmdb(query)
   require "net/http"
   require "json"

   api_key = ENV["TMDB_API_KEY"]
   return [] unless api_key

   encoded_query = URI.encode_www_form_component(query)
   url = URI("https://api.themoviedb.org/3/search/movie?api_key=#{api_key}&language=it-IT&query=#{encoded_query}")

   response = Net::HTTP.get_response(url)

   if response.is_a?(Net::HTTPSuccess)
     data = JSON.parse(response.body)
     process_tmdb_results(data["results"] || [])
   else
     []
   end
  end

  def process_tmdb_results(results)
   results.first(10).map do |movie|
     {
       id: movie["id"],
       title: movie["title"],
       year: extract_year(movie["release_date"]),
       poster_path: movie["poster_path"],
       poster_url: movie["poster_path"] ? "https://image.tmdb.org/t/p/w185#{movie["poster_path"]}" : nil,
       overview: movie["overview"]&.truncate(150)
     }
   end
  end

  def extract_year(date_string)
   return nil unless date_string
   Date.parse(date_string).year
  rescue
   nil
  end

  def update
    if params[:current_password].blank? || !@user.authenticate(params[:current_password])
      flash.now[:alert] = "Password attuale errata"
      render :profile_index, status: :unauthorized
      return
    end

    if @user.update(user_params)
      redirect_to profile_path, notice: "Profilo aggiornato con successo"
    else
      flash.now[:alert] = "Errore nell'aggiornamento del profilo"
      render :profile_index, status: :unprocessable_entity
    end
  end


  private

  def set_user
    @user = current_user
  end

  def require_login
    unless current_user
      redirect_to login_path, alert: "Devi accedere prima."
    end
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :birth_date,
      :username,
      :email,
      :avatar
    )
  end
end
