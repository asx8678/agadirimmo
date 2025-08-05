class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  # Protect from CSRF attacks
  protect_from_forgery with: :exception

  before_action :set_locale

  private

  def set_locale
    I18n.locale = params[:locale].presence_in(%w[en pl]) || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }.compact
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  helper_method :current_user

  def require_sign_in!
    redirect_to sign_in_path, alert: "Please sign in" unless current_user
  end

  def rotate_session!
    # Rotate session ID to prevent session fixation
    reset_session if session[:user_id].present?
  end

  def check_session_expiry
    if session[:expires_at] && session[:expires_at] < Time.current
      reset_session
      redirect_to sign_in_path, alert: "Your session has expired. Please sign in again."
    else
      session[:expires_at] = 24.hours.from_now
    end
  end
end
