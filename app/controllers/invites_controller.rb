class InvitesController < ApplicationController
  before_action :require_user

  def create
    if invite_params.values.all? { |param| param.present? }
      if User.find_by(email_address: params[:friend_email]).present?
        flash[:danger] = "User with this email already exists in the system!"
        render :new
      else
        @name, @mail, @message = invite_params.values
        current_user.update_column(:invite_token, SecureRandom.urlsafe_base64) unless current_user.invite_token
        UserMailer.send_invite(current_user, @name, @mail, @message, current_user.invite_token).deliver
        flash[:success] = "Invitation has been sent!"
        redirect_to home_path
      end
    else
      flash[:danger] = "Please fill in all the fields!"
      render :new
    end
  end

  private

  def invite_params
    params.permit(:friend_name, :friend_email, :message)
  end
end
