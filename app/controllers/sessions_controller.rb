class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      redirect_to salahs_path, notice: "Welcome back!"
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  def destroy
    session[:user_id] = nil  
    redirect_to new_session_path
  end
end
