class UserMailer < ActionMailer::Base
  def welcome_email(user)
    @user = user
    @url = root_url

    mail(from: 'example@email.com',
          to: user.email_address,
          subject: "Welcome to myFlix!")
  end

  def reset_password(user, token)
    @user = user
    @token = token

    mail from: 'example@email.com',
          to: @user.email_address,
          subject: "Password reset was requested"
  end

  def send_invite(existing_user, new_user_name, email, message, token)
    @existing_user = existing_user
    @name = new_user_name
    @email = email
    @message = message
    @token = token

    mail(from: 'example@email.com',
          to: @email,
          subject: "You have been invited to myFlix!")
  end
end
