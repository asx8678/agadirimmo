class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params.dig(:session, :email))
    if user&.authenticate(params.dig(:session, :password))
      # Reset session for security (prevent session fixation)
      reset_session
      session[:user_id] = user.id
      session[:expires_at] = 24.hours.from_now
      redirect_to root_path, notice: "Signed in successfully"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "Signed out"
  end
end
