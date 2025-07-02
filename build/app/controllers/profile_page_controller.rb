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
    [@user.tmdb_id_1, @user.tmdb_id_2, @user.tmdb_id_3].each do |tmdb_id|
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
    tmdb_id = params[:tmdb_id]

    case position
    when 1
      @user.update(tmdb_id_1: tmdb_id)
    when 2
      @user.update(tmdb_id_2: tmdb_id)
    when 3
      @user.update(tmdb_id_3: tmdb_id)
    end

    redirect_to profile_path, notice: "Film aggiornato con successo!"
  rescue => e
    Rails.logger.error "Errore nell'aggiornamento: #{e.message}"
    redirect_to profile_path, alert: "Errore nell'aggiornamento del film"
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