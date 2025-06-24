class ProfilePageController < ApplicationController
  
  before_action :require_login
  before_action :set_user

  def profile_index
    @trending_movies = Rails.cache.fetch("trending_movies_top3", expires_in: 6.hours) do
      TmdbService.trending_movies.first(3)
    end
  
    @chosen_movies = []
  
    [@user.tmdb_id_1, @user.tmdb_id_2, @user.tmdb_id_3].each do |tmdb_id|
      if tmdb_id.present?
        movie = TmdbService.get_movie(tmdb_id)
        @chosen_movies << movie if movie
      else
        @chosen_movies << nil
      end
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