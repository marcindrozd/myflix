require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end

    it_behaves_like "requires admin" do
      let(:action) { get :new }
    end

    it "sets @video to new video" do
      bob = Fabricate(:admin)
      set_current_user(bob)
      get :new
      expect(assigns(:video)).to be_instance_of(Video)
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end

    it_behaves_like "requires admin" do
      let(:action) { post :create }
    end

    context "with valid input" do
      it "redirects to add new video page" do
        bob = Fabricate(:admin)
        set_current_user(bob)
        category = Fabricate(:category)
        post :create, video: { title: "futurama", category_id: category.id, description: "fantastic show" }
        expect(response).to redirect_to new_admin_video_path
      end

      it "creates video" do
        bob = Fabricate(:admin)
        set_current_user(bob)
        category = Fabricate(:category)
        post :create, video: { title: "futurama", category_id: category.id, description: "fantastic show" }
        expect(category.videos.count).to eq(1)
      end

      it "flashes success message" do
        bob = Fabricate(:admin)
        set_current_user(bob)
        category = Fabricate(:category)
        post :create, video: { title: "futurama", category_id: category.id, description: "fantastic show" }
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input" do
      it "does not create a video" do
        bob = Fabricate(:admin)
        set_current_user(bob)
        category = Fabricate(:category)
        post :create, video: { title: "", category_id: category.id, description: "fantastic show" }
        expect(category.videos.count).to eq(0)
      end

      it "renders :new template" do
        bob = Fabricate(:admin)
        set_current_user(bob)
        category = Fabricate(:category)
        post :create, video: { title: "", category_id: category.id, description: "fantastic show" }
        expect(response).to render_template :new
      end

      it "assigns @video template" do
        bob = Fabricate(:admin)
        set_current_user(bob)
        category = Fabricate(:category)
        post :create, video: { title: "", category_id: category.id, description: "fantastic show" }
        expect(assigns(:video)).to be_instance_of(Video)
      end

      it "flashes error message" do
        bob = Fabricate(:admin)
        set_current_user(bob)
        category = Fabricate(:category)
        post :create, video: { title: "", category_id: category.id, description: "fantastic show" }
        expect(flash[:danger]).to be_present
      end
    end
  end
end
