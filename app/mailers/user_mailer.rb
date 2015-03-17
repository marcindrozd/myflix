class UserMailer < ActionMailer::Base
  def welcome_email(user_id)
    @user = User.find(user_id)
    @url = root_url

    mail(from: 'example@email.com',
          to: @user.email_address,
          subject: "Welcome to myFlix!")
  end

  def reset_password(user_id, token)
    @user = User.find(user_id)
    @token = token

    mail from: 'example@email.com',
          to: @user.email_address,
          subject: "Password reset was requested"
  end

  def send_invite(invitation_id)
    @invitation = Invite.find(invitation_id)

    mail(from: 'example@email.com',
          to: @invitation.friend_email,
          subject: "You have been invited to myFlix!")
  end
end
