require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it "assigns @video variable if user is admin" do
      bob = Fabricate(:user, admin: true)
      set_current_user(bob)
      get :new
      expect(assigns(:video)).to be_present
    end

    it "redirects user to root path if user is not an admin" do
      bob = Fabricate(:user, admin: false)
      set_current_user(bob)
      get :new
      expect(response).to redirect_to root_path
    end

    it "redirects to root path if no user signed in" do
      get :new
      expect(response).to redirect_to root_path
    end
  end
end
