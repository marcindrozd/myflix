require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "creates User object" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "GET new_with_invite" do
    it "renders new template" do
      invitation = Fabricate(:invite)
      get :new_with_invite, token: invitation.invite_token
      expect(response).to render_template :new
    end

    it "sets user with invited user's email" do
      invitation = Fabricate(:invite)
      get :new_with_invite, token: invitation.invite_token
      expect(assigns(:user).email_address).to eq(invitation.friend_email)
    end

    it "redirects to expired token page when token is not valid" do
      Fabricate(:invite, invite_token: "abcd")
      get :new_with_invite, token: "xyz"
      expect(response).to redirect_to invalid_token_path
    end
  end

  describe "POST create" do
    context "with valid personal info and valid card" do
      let(:charge) { double(:charge, successful?: true) }

      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "creates a user" do
        expect(User.count).to eq(1)
      end

      it "redirects to home for successfully created user" do
        expect(response).to redirect_to home_path
      end
    end

    context "with valid personal info and invalid card" do
      it "renders the new template" do
        charge = double(:charge, successful?: false, error_message: "Your card was declined")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: "123"
        expect(response).to render_template :new
      end

      it "does not create a new user record" do
        charge = double(:charge, successful?: false, error_message: "Your card was declined")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: "123"
        expect(User.count).to eq(0)
      end

      it "sets error message" do
        charge = double(:charge, successful?: false, error_message: "Your card was declined")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: "123"
        expect(flash[:danger]).to be_present
      end
    end

    context "with invalid personal info" do
      before do
        post :create, user: { full_name: Faker::Name.name, password: "password" }
      end

      it "does not create a new user" do
        expect(User.count).to eq(0)
      end

      it "renders new template" do
        expect(response).to render_template :new
      end

      it "does not charge the credit card" do
        StripeWrapper::Charge.should_not_receive(:create)
      end
    end

    context "sending email" do
      let(:charge) { double(:charge, successful?: true) }

      before do
        UserMailer.deliveries.clear
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end

      it "send an email" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(UserMailer.deliveries.count).to eq(1)
      end

      it "sends the email to correct recipient" do
        post :create, user: Fabricate.attributes_for(:user, email_address: "alice@example.com")
        expect(UserMailer.deliveries.last.to).to eq(["alice@example.com"])
      end

      it "sends the email with correct content" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(UserMailer.deliveries.last.body).to have_content("Welcome to myFlix")
      end
    end

    context "when user was invited" do
      let(:bob) { Fabricate(:user) }
      let(:alice_attributes) { Fabricate.attributes_for(:user, full_name: "Alice Black") }
      let(:invitation) { Fabricate(:invite, inviter: bob, friend_name: "Alice Black") }
      let(:charge) { double(:charge, successful?: true) }

      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end

      it "finds the inviter by invite token" do
        post :create, user: alice_attributes.merge!(invite_token: invitation.invite_token)
        expect(assigns(:inviter)).to eq(bob)
      end

      it "follows the inviter" do
        post :create, user: alice_attributes.merge!(invite_token: invitation.invite_token)
        expect(User.find_by(full_name: "Alice Black").friends).to include(bob)
      end

      it "adds the new user to inviter followings" do
        post :create, user: alice_attributes.merge!(invite_token: invitation.invite_token)
        expect(bob.friends).to include(User.find_by(full_name: "Alice Black"))
      end

      it "expires the invitation token after user was registered" do
        post :create, user: alice_attributes.merge!(invite_token: invitation.invite_token)
        expect(Invite.first.invite_token).to be_blank
      end
    end
  end

  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 3 }
    end

    it "assigns @user variable" do
      set_current_user
      bob = Fabricate(:user)
      get :show, id: bob.id
      expect(assigns(:user)).to eq(bob)
    end
  end
end
