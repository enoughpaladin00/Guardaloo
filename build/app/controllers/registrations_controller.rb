class RegistrationsController < ApplicationController
  def create
    user = User.new(user_params)

    if user.save
      session[:user_id] = user.id
      render json: { success: true, redirect_url: home_path }
    else
      render json: { success: false, errors: user.errors.full_messages, redirect_url: root_path }, status: :unprocessable_entity
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
