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
      response.should redirect_to root_path
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
      response.should redirect_to root_path
    end
  end
end
