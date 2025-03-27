class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @current_user ||= Session.find_by(id: cookies.signed[:session_id])&.user
  end

  def authenticate_user!
    redirect_to new_session_path, alert: "Please log in to continue." unless current_user
  end
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end
