require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it "sets @video to new video" do
      bob = Fabricate(:admin)
      set_current_user(bob)
      get :new
      expect(assigns(:video)).to be_instance_of(Video)
    end

    it "redirects user to root path if user is not an admin" do
      bob = Fabricate(:user)
      set_current_user(bob)
      get :new
      expect(response).to redirect_to root_path
    end

    it "flashes error message for non admin" do
      bob = Fabricate(:user)
      set_current_user(bob)
      get :new
      expect(flash[:danger]).to be_present
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end
  end
end
