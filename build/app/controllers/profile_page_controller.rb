class ProfilePageController < ApplicationController
  before_action :authenticate_user!
  before_action :require_login
  before_action :set_user

  def profile_index

    # Film scelti dall'utente (fissi sul profilo) - usa TmdbService.get_movie
    @chosen_movies = []
    [@user.tmdb_id_1, @user.tmdb_id_2, @user.tmdb_id_3].each do |tmdb_id|
      if tmdb_id.present?
        movie = TmdbService.get_movie(tmdb_id)
        @chosen_movies << movie
      else
        @chosen_movies << nil
      end
    end
    
    # Prendi gli ultimi 10 tmdb_id dai preferiti dell'utente
    bookmark_tmdb_ids = @user.bookmarks.order(created_at: :desc).limit(10).pluck(:tmdb_id)
    
    # Usa il TmdbService esistente - stessa logica di @trending_movies
    @preferiti = bookmark_tmdb_ids.filter_map do |tmdb_id|
      TmdbService.new.fetch_movie_details(tmdb_id, "movie")
    rescue => e
      Rails.logger.error "Errore nel recuperare il film #{tmdb_id}: #{e.message}"
      nil
    end
  end
  
  # Metodo per cercare film - usa search_movie_by_title
  def search_movies
    query = params[:query]
    if query.present?
      @search_results = TmdbService.search_movie_by_title(query)
      render json: @search_results
    else
      render json: { error: "Query vuota" }, status: 400
    end
  end
  
  # Metodo per salvare il film scelto
  def update_chosen_movie
    movie_id = params[:movie_id]
    position = params[:position].to_i # 1, 2, o 3
    
    if position.between?(1, 3) && movie_id.present?
      case position
      when 1
        @user.update(tmdb_id_1: movie_id)
      when 2
        @user.update(tmdb_id_2: movie_id)
      when 3
        @user.update(tmdb_id_3: movie_id)
      end
      
      render json: { success: true, message: "Film salvato!" }
    else
      render json: { error: "Parametri non validi" }, status: 400
    end
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