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

  describe "GET index" do
    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end

    it "assigns @friends variable" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      charlie = Fabricate(:user)
      set_current_user(bob)
      friend_alice = Fabricate(:friendship, user_id: bob.id, friend_id: alice.id)
      friend_charlie = Fabricate(:friendship, user_id: bob.id, friend_id: charlie.id)
      get :index
      expect(assigns(:friendships)).to eq([friend_alice, friend_charlie])
    end
  end
end
