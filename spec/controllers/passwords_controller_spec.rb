require 'spec_helper'

describe PasswordsController do
  describe "POST request_token" do
    before { UserMailer.deliveries.clear }

    context "with blank email address" do
      it "flashes the error message" do
        post :request_token, email: ""
        expect(flash.now[:danger]).to eq("Email cannot be blank!")
      end

      it "renders the forgot password page" do
        post :request_token, email: ""
        expect(response).to render_template :forgot_password
      end
    end

    context "with valid email address" do
      it "redirects to confirm password reset path" do
        bob = Fabricate(:user)
        post :request_token, email: bob.email_address
        expect(response).to redirect_to confirm_password_reset_path
      end

      it "finds user by email address" do
        bob = Fabricate(:user)
        post :request_token, email: bob.email_address
        expect(assigns(:user)).to eq(bob)
      end

      it "generates new token for found user" do
        bob = Fabricate(:user)
        post :request_token, email: bob.email_address
        expect(bob.reload.token).not_to be_blank
      end

      it "sends email for existing user" do
        bob = Fabricate(:user)
        post :request_token, email: bob.email_address
        expect(UserMailer.deliveries.last.to).to eq([bob.email_address])
      end

      it "sends email with generated token" do
        bob = Fabricate(:user)
        post :request_token, email: bob.email_address
        expect(UserMailer.deliveries.last.body).to include(bob.reload.token)
      end
    end

    context "with invalid email address" do
      it "flashes error message if given email address is not found" do
        bob = Fabricate(:user)
        post :request_token, email: "text@wrong_email.com"
        expect(flash.now[:danger]).to eq("User with this email does not exist!")
      end

      it "does not send an email when email address is not found" do
        bob = Fabricate(:user)
        post :request_token, email: "text@wrong_email.com"
        expect(UserMailer.deliveries.count).to eq(0)
      end
    end
  end

  describe "POST new_password" do
    context "with valid token" do
      it "redirects to sign in page" do
        bob = Fabricate(:user)
        token = SecureRandom.urlsafe_base64
        bob.update_attributes(token: token)
        post :new_password, token: token
        expect(response).to redirect_to sign_in_path
      end

      it "finds the user by the token" do
        bob = Fabricate(:user)
        token = SecureRandom.urlsafe_base64
        bob.update_attributes(token: token)
        post :new_password, token: token
        expect(assigns(:user)).to eq(bob)
      end

      it "sets the new password for the user" do
        bob = Fabricate(:user)
        old_password = bob.password
        token = SecureRandom.urlsafe_base64
        bob.update_attributes(token: token)
        post :new_password, token: token, password: "password"
        expect(bob.reload.password).to eq("password")
      end

      it "displays success message" do
        bob = Fabricate(:user)
        token = SecureRandom.urlsafe_base64
        bob.update_attributes(token: token)
        post :new_password, token: token
        expect(flash[:success]).not_to be_blank
      end

      it "deletes the token from database after successful password reset" do
        bob = Fabricate(:user)
        token = SecureRandom.urlsafe_base64
        bob.update_attributes(token: token)
        post :new_password, token: token, password: "password"
        expect(bob.reload.token).to be_nil
      end
    end

    context "with invalid token" do
      it "redirects to invalid token path if token is not found" do
        bob = Fabricate(:user)
        old_password = bob.password
        token = SecureRandom.urlsafe_base64
        bob.update_attributes(token: token)
        post :new_password, token: "abcd", password: "password"
        expect(response).to redirect_to invalid_token_path
      end

      it "does not set a new password when token is incorrect" do
        bob = Fabricate(:user)
        old_password = bob.password
        token = SecureRandom.urlsafe_base64
        bob.update_attributes(token: token)
        post :new_password, token: "abcd", password: "password"
        expect(bob.reload.password).to eq(old_password)
      end
    end
  end
end
