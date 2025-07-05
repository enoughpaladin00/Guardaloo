class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def user_signed_in?
    current_user.present?
  end

  def authenticate_user!
    redirect_to root_path, alert: "Effettua il login" unless user_signed_in?
  end

  # Metodo per limitare accesso ad amministratori
  def authenticate_admin!
    unless user_signed_in? && current_user.admin?
      redirect_to root_path, alert: "Accesso riservato agli amministratori."
    end
  end

  # Metodo per limitare accesso ad admin o moderatori
  def authenticate_moderator_or_admin!
    unless user_signed_in? && (current_user.admin? || current_user.moderator?)
      redirect_to root_path, alert: "Accesso riservato ai moderatori o amministratori."
    end
  end

private

  def authorize_user!
    unless current_user.admin? || current_user.moderator? || current_user == @post.user
      redirect_to root_path, alert: "Non sei autorizzato a modificare questo post"
    end
  end

end
