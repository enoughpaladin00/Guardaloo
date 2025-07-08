class RegistrationsController < ApplicationController
  def create
    user = User.new(user_params)

    if user.save
      session[:user_id] = user.id

      respond_to do |format|
        format.html { redirect_to home_path, notice: "Registrazione completata con successo" }
        format.json { render json: { success: true, redirect_url: home_path } }
      end
    else
      respond_to do |format|
        format.html do
          flash[:alert] = user.errors.full_messages.join(", ")
          redirect_to root_path
        end
        format.json do
          render json: { success: false, errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end


  private

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :birth_date,
      :username,
      :email,
      :password,
      :password_confirmation
    )
  end
end
