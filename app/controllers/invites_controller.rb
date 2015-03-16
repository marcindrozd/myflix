class InvitesController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invite.new
  end

  def create
    @invitation = current_user.invites.new(invite_params)

    if @invitation.save
      @invitation.update_column(:invite_token, SecureRandom.urlsafe_base64)
      UserMailer.send_invite(@invitation).deliver
      flash[:success] = "Invitation has been sent!"
      redirect_to new_invite_path
    else
      flash[:danger] = "Please fill in all the fields!"
      render :new
    end
  end

  private

  def invite_params
    params.require(:invite).permit(:friend_name, :friend_email, :message)
  end
end
