class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id

      if params[:lat].present? && params[:lng].present?
        session[:user_location] = { lat: params[:lat], lng: params[:lng] }
        Rails.logger.info "Location salvata in sessione: #{session[:user_location]}"
      else
        Rails.logger.warn "Nessuna location fornita durante login"
      end

      respond_to do |format|
        format.html { redirect_to "/home", notice: "Login effettuato con successo!" }
        format.json { render json: { success: true, redirect_url: "/home/" }, status: :ok }
      end
    else
      respond_to do |format|
        format.html do
          flash[:alert] = "Email o password errati"
          redirect_to root_path
        end

        format.json do
          render json: { success: false, error: "Email o password non corretti" }, status: :unauthorized
        end
      end
    end
  end

  def omniauth
    user = User.from_omniauth(request.env['omniauth.auth'])
    Rails.logger.info "User from omniauth: #{user.inspect}"

    if user.persisted?
      session[:user_id] = user.id
      provider = request.env['omniauth.auth']['provider'].capitalize

      redirect_to "/home", notice: "Accesso effettuato con #{provider}"
    else
      redirect_to root_path, alert: "Autenticazione fallita"
    end
  end

  def destroy
    session[:user_id] = nil
    session[:user_location] = nil

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Sei stato disconnesso" }
      format.json { render json: { success: true, redirect_url: root_path } }
    end
  end
end
