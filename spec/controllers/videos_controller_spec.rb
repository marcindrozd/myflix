require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it "sets the @video variable for authenticated user" do
      session[:user_id] = Fabricate(:user).id
      movie = Fabricate(:video)
      get :show, id: movie.id
      expect(assigns(:video)).to eq(movie)
    end

    it "redirects unauthenticated user to root path" do
      movie = Fabricate(:video)
      get :show, id: movie.id
      expect(response).to redirect_to root_path
    end

    it "sets the @reviews variable" do
      session[:user_id] = Fabricate(:user).id
      movie = Fabricate(:video)
      review1 = Fabricate(:review, video: movie)
      review2 = Fabricate(:review, video: movie)
      get :show, id: movie.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end
  end

  describe "GET search" do
    it "sets @videos to array with titles variable when there is a match" do
      session[:user_id] = Fabricate(:user).id
      movie = Fabricate(:video, title: "Ghostbusters")
      get :search, video: "host"
      expect(assigns(:videos)).to eq([movie])
    end

    it "redirects unathenticated user to root path" do
      movie = Fabricate(:video)
      get :search, video: "host"
      expect(response).to redirect_to root_path
    end
  end
end
