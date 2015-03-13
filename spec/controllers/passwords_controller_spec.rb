require 'spec_helper'

describe PasswordsController do
  describe "POST request_token" do
    before { UserMailer.deliveries.clear }

    it "redirects to root_path" do
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

    it "flashes error message if given email address is not found" do
      bob = Fabricate(:user)
      post :request_token, email: "text@wrong_email.com"
      expect(flash.now[:danger]).not_to be_blank
    end

    it "does not send an email when email address is not found" do
      bob = Fabricate(:user)
      post :request_token, email: "text@wrong_email.com"
      expect(UserMailer.deliveries.count).to eq(0)
    end
  end
end
