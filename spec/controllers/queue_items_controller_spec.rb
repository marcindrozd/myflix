require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items variable for authenticated user" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      queue_item1 = Fabricate(:queue_item, user: bob)
      queue_item2 = Fabricate(:queue_item, user: bob)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it "redirects unauthenticated user to root path" do
      get :index
      expect(response).to redirect_to root_path
    end
  end

  describe "POST create" do
    it "creates a new item in queue items"
    it "creates a new item with the next available order"
    it "does not create a new item if item is already in the queue"
    it "redirects to my_queue site"
    it "redirects to root path for unauthenticated user"
  end
end
