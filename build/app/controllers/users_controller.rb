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

    def toggle_role
      user = User.find(params[:id])
      if current_user.admin? && user != current_user
        user.role = user.role == "user" ? "moderator" : "user"
        user.save
      end
      head :ok
    end



    private

    def tmdb_params
      params.require(:user).permit(:tmdb_fav1, :tmdb_fav2, :tmdb_fav3)
    end

    def require_login
      redirect_to login_path, alert: "Devi accedere prima." unless current_user
    end

end
