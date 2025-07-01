class UsersController < ApplicationController
    before_action :require_login
  
    def update_tmdb_id
      user = current_user
  
      if user.update(tmdb_params)
        render json: { success: true, message: "Film aggiornati" }
      else
        render json: { success: false, errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    private
  
    def tmdb_params
      params.require(:user).permit(:tmdb_id_1, :tmdb_id_2, :tmdb_id_3)
    end
  
    def require_login
      redirect_to login_path, alert: "Devi accedere prima." unless current_user
    end
end
