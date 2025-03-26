class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    user = User.authenticate_by(params.permit(:email_address, :password))
    if user
      session[:user_id] = user.id
      redirect_to new_salah_path, notice: "Welcome! Please log your Salah."
    else
      flash.now[:alert] = "Invalid email address or password."
      render :new
    end
  end


  def destroy
    terminate_session
    redirect_to new_session_path, notice: "You have been logged out."
  end
end
