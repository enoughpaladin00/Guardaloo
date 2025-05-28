class ProfilePageController < ApplicationController
  before_action :set_user

  def profile_index
    unless current_user
      redirect_to login_path, alert: "Devi accedere prima."
      return
    end
  end

  def update
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

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :birth_date,
      :username,
      :email,
      :avatar,
      :password,
      :password_confirmation
    )
  end
end
