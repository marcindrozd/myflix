class PasswordsController < ApplicationController
  def forgot_password
  end

  def request_token
    @user = User.find_by(email_address: params[:email])
    @token = SecureRandom.urlsafe_base64

    if @user
      @user.update_attributes(token: @token)
      UserMailer.reset_password(@user, @token).deliver
      redirect_to confirm_password_reset_path
    else
      flash.now[:danger] = "User with this email does not exist!"
      render :forgot_password
    end
  end
end
