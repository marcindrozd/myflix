class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    redirect_to home_path if logged_in?
    @user = User.new
  end

  def new_with_invite
    @invitation = find_invite(params[:token])

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

    if @user.save
      invite_token = params[:user][:invite_token]
      flash[:success] = "You have been registered successfully!"
      session[:user_id] = @user.id
      UserMailer.delay.welcome_email(@user.id)

      if invite_token.present?
        invite = find_invite(invite_token)
        @inviter = invite.inviter
        @user.follow(@inviter)
        @inviter.follow(@user)
        invite.remove_token!
      end

      redirect_to home_path
    else
      @token = params[:user][:invite_token]
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

  def find_invite(token)
    Invite.find_by(invite_token: token)
  end
end
