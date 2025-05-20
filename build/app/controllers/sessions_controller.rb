class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      render json: { success: true }
    else
      render json: { success: false, error: "Email o password non corretti" }, status: :unauthorized
    end
  end

  def omniauth
    user = User.from_omniauth(request.env['omniauth.auth'])
    Rails.logger.info "User from omniauth: #{user.inspect}"

    if user.persisted?
      session[:user_id] = user.id
      redirect_to "/home", notice: "Accesso effettuato con Google"
    else
      redirect_to root_path, alert: "Autenticazione fallita"
    end
  end

  def passthru
    render status: 404, plain: "Not found. Authentication passthru."
  end


  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Sei stato disconnesso"
  end
end
