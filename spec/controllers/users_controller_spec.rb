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
    context "successful user sign up" do
      it "redirects to home for successfully created user" do
        result = double(:sign_up_result, successful?: true)
        UserSignUp.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: "123"
        expect(response).to redirect_to home_path
      end
    end

    context "failed user sign up" do
      it "renders the new template" do
        result = double(:sign_up_result, successful?: false, error_message: "Test error message.")
        UserSignUp.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: { email_address: "tex@example.com" }
        expect(response).to render_template :new
      end

      it "sets error message" do
        result = double(:sign_up_result, successful?: false, error_message: "Test error message.")
        UserSignUp.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: { email_address: "tex@example.com" }
        expect(flash[:danger]).to eq("Test error message.")
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
