require 'spec_helper'

describe UserSignUp do
  context "with valid personal info and valid card" do
    let(:customer) { double(:customer, successful?: true) }

    before do
      StripeWrapper::Customer.should_receive(:create).and_return(customer)
    end

    it "creates a user" do
      UserSignUp.new(Fabricate.build(:user)).sign_up("stripe_token", nil)
      expect(User.count).to eq(1)
    end
  end

  context "with valid personal info and invalid card" do
    it "does not create a new user record" do
      customer = double(:customer, successful?: false, error_message: "Your card was declined")
      StripeWrapper::Customer.should_receive(:create).and_return(customer)
      UserSignUp.new(Fabricate.build(:user)).sign_up("stripe_token", nil)
      expect(User.count).to eq(0)
    end
  end

  context "with invalid personal info" do
    it "does not create a new user" do
      UserSignUp.new(Fabricate.build(:user, email_address: "")).sign_up("stripe_token", nil)
      expect(User.count).to eq(0)
    end

    it "does not charge the credit card" do
      StripeWrapper::Customer.should_not_receive(:create)
      UserSignUp.new(Fabricate.build(:user, email_address: "")).sign_up("stripe_token", nil)
    end
  end

  context "sending email" do
    let(:customer) { double(:customer, successful?: true) }

    before do
      UserMailer.deliveries.clear
      StripeWrapper::Customer.should_receive(:create).and_return(customer)
    end

    it "send an email" do
      UserSignUp.new(Fabricate.build(:user)).sign_up("stripe_token", nil)
      expect(UserMailer.deliveries.count).to eq(1)
    end

    it "sends the email to correct recipient" do
      UserSignUp.new(Fabricate.build(:user, email_address: "alice@example.com")).sign_up("stripe_token", nil)
      expect(UserMailer.deliveries.last.to).to eq(["alice@example.com"])
    end

    it "sends the email with correct content" do
      UserSignUp.new(Fabricate.build(:user)).sign_up("stripe_token", nil)
      expect(UserMailer.deliveries.last.body).to include("Welcome to myFlix")
    end
  end

  context "when user was invited" do
    let(:bob) { Fabricate(:user) }
    let(:invitation) { Fabricate(:invite, inviter: bob, friend_name: "Alice Black") }
    let(:customer) { double(:customer, successful?: true) }

    before do
      StripeWrapper::Customer.should_receive(:create).and_return(customer)
      UserSignUp.new(Fabricate.build(:user, full_name: "Alice Black")).sign_up("stripe_token", invitation.invite_token)
    end

    it "finds the inviter by invite token" do
      expect(invitation.inviter).to eq(bob)
    end

    it "follows the inviter" do
      expect(User.find_by(full_name: "Alice Black").friends).to include(bob)
    end

    it "adds the new user to inviter followings" do
      expect(bob.friends).to include(User.find_by(full_name: "Alice Black"))
    end

    it "expires the invitation token after user was registered" do
      expect(Invite.first.invite_token).to be_blank
    end
  end
end
