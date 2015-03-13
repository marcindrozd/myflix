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
      if params[:email].blank?
        flash.now[:danger] = "Email cannot be blank!"
      else
        flash.now[:danger] = "User with this email does not exist!"
      end
      render :forgot_password
    end
  end

  def reset_password
  end

  def new_password
    @user = User.find_by_token(params[:token])

    if @user
      @user.password = params[:password]
      flash[:success] = "Password reset was successful. You may now log in with your new password!"
      @user.update_attributes(token: nil)
      redirect_to sign_in_path
    else
      redirect_to invalid_token_path
    end
  end
end
