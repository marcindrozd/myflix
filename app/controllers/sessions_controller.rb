class SessionsController < ApplicationController
  def new
    redirect_to home_path if logged_in?
  end

  def create
    user = User.find_by(email_address: params[:session][:email_address])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success] = "Hi #{user.full_name}! You are now logged in!"
      redirect_to home_path
    else
      flash.now[:danger] = "There is something wrong with your username or password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have been successfully logged out."
    redirect_to root_path
  end
end
