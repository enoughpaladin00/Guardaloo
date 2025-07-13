
class CinemaFavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    cinema = Cinemasdef.find(params[:cinema_id]) 
    cinema_favorite = current_user.cinema_favorites.find_or_create_by(cinemasdef: cinema) 
    if cinema_favorite.persisted? 
      render json: { status: 'added', message: 'Cinema aggiunto ai preferiti!' }, status: :ok
    else
      render json: { status: 'error', message: cinema_favorite.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { status: 'error', message: 'Cinema non trovato.' }, status: :not_found
  rescue StandardError => e
    render json: { status: 'error', message: "Si è verificato un errore: #{e.message}" }, status: :internal_server_error
  end

  def destroy
    #occhio!!
    cinema = Cinemasdef.find(params[:id]) 
    
    cinema_favorite = current_user.cinema_favorites.find_by(cinemasdef: cinema)
    
    if cinema_favorite&.destroy
      render json: { status: 'removed', message: 'Cinema rimosso dai preferiti.' }, status: :ok
    else
      render json: { status: 'error', message: 'Impossibile rimuovere il cinema dai preferiti o non trovato.' }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { status: 'error', message: 'Cinema non trovato.' }, status: :not_found
  rescue StandardError => e
    render json: { status: 'error', message: "Si è verificato un errore: #{e.message}" }, status: :internal_server_error
  end
end