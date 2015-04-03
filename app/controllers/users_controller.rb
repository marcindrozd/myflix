class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    redirect_to home_path if logged_in?
    @user = User.new
  end

  def new_with_invite
    @invitation = Invite.find_by(invite_token: params[:token])

    if @invitation
      @user = User.new(email_address: @invitation.friend_email)
      @token = @invitation.invite_token
      render :new
    else
      redirect_to invalid_token_path
    end
  end

  def create
    @user = User.new(user_params)

    result = UserSignUp.new(@user).sign_up(params[:stripeToken], params[:user][:invite_token])

    if result.successful?
      flash[:success] = "You have been registered successfully!"
      session[:user_id] = @user.id
      redirect_to home_path
    else
      @token = params[:user][:invite_token]
      flash[:danger] = result.error_message
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email_address, :password)
  end
end
