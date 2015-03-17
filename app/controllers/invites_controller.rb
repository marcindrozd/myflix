class InvitesController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invite.new
  end

  def create
    @invitation = current_user.invites.new(invite_params)

    if @invitation.save
      @invitation.generate_token!
      UserMailer.delay.send_invite(@invitation.id)
      flash[:success] = "Invitation has been sent!"
      redirect_to new_invite_path
    else
      flash.now[:danger] = "Please fill in all the fields!"
      render :new
    end
  end

  private

  def invite_params
    params.require(:invite).permit(:friend_name, :friend_email, :message)
  end
end
