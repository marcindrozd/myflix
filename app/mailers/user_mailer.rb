class UserMailer < ActionMailer::Base
  def welcome_email(user)
    @user = user
    @url = 'http://md-myflix.herokuapp.com'

    mail(from: 'example@email.com',
          to: user.email_address,
          subject: "Welcome to myFlix!")
  end
end
