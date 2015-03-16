class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    redirect_to home_path if logged_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      invite_token = params[:user][:invite_token]
      flash[:success] = "You have been registered successfully!"
      session[:user_id] = @user.id
      UserMailer.welcome_email(@user).deliver

      if invite_token
        @inviter = User.find_by(invite_token: invite_token)
        current_user.friends << @inviter
        @inviter.friends << current_user
      end

      redirect_to home_path
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email_address, :password, :invite_token)
  end
end
