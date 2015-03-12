require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "creates User object" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with valid data" do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "creates a user" do
        expect(User.count).to eq(1)
      end

      it "redirects to home for successfully created user" do
        expect(response).to redirect_to home_path
      end
    end

    context "with invalid data" do
      before do
        post :create, user: { full_name: Faker::Name.name, password: "password" }
      end

      it "does not create a new user" do
        expect(User.count).to eq(0)
      end

      it "renders new template" do
        expect(response).to render_template :new
      end
    end

    context "sending email" do
      after { UserMailer.deliveries.clear }

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
