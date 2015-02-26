require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    context "with authenticated user" do
      let(:current_user) { Fabricate(:user) }

      before do
        session[:user_id] = current_user.id
      end

      context "with valid content" do
        it "redirects to video page" do
          video = Fabricate(:video)
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(response).to redirect_to video_path(video)
        end

        it "saves the review" do
          video = Fabricate(:video)
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(Review.count).to eq(1)
        end

        it "saves the review associated with video" do
          video = Fabricate(:video)
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(Review.first.video).to eq(video)
        end

        it "saves the review associated with authenticated user" do
          video = Fabricate(:video)
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(Review.first.user).to eq(current_user)
        end
      end

      context "with invalid content" do
        it "does not save the review" do
          video = Fabricate(:video)
          post :create, review: { rating: "3" }, video_id: video.id
          expect(Review.count).to eq(0)
        end

        it "renders videos#show page" do
          video = Fabricate(:video)
          post :create, review: { rating: "3" }, video_id: video.id
          expect(response).to render_template 'videos/show'
        end

        it "sets @video variable" do
          video = Fabricate(:video)
          post :create, review: { rating: "3" }, video_id: video.id
          expect(assigns(:video)).to eq(video)
        end

        it "sets @reviews variable" do
          video = Fabricate(:video)
          review = Fabricate(:review, video: video)
          post :create, review: { rating: "3" }, video_id: video.id
          expect(assigns(:reviews)).to match_array([review])
        end
      end
    end

    context "with unathenticated user" do
      it "does not save the review" do
        video = Fabricate(:video)
        post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        expect(Review.count).to eq(0)
      end

      it "redirects user to root path" do
        video = Fabricate(:video)
        post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        expect(response).to redirect_to root_path
      end
    end
  end
end
