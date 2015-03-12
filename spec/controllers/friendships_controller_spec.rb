require 'spec_helper'

describe FriendshipsController do
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

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create, friend_id: 3 }
    end

    it "redirects to people page" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(alice)
      post :create, friend_id: bob.id
      expect(response).to redirect_to(people_path)
    end

    it "assigns @friend variable" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(alice)
      post :create, friend_id: bob.id
      expect(assigns(:friend)).to eq(bob)
    end

    it "adds selected user to current user's friends list" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(alice)
      post :create, friend_id: bob.id
      expect(alice.reload.friends).to include(bob)
    end

    it "does not add selected user to friends list if selected user is already followed" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(alice)
      Friendship.create(user: alice, friend: bob)
      post :create, friend_id: bob.id
      expect(alice.reload.friends.count).to eq(1)
    end

    it "does not add user to friends list if selected user is current user" do
      alice = Fabricate(:user)
      set_current_user(alice)
      post :create, friend_id: alice.id
      expect(alice.reload.friends.count).to eq(0)
    end

    it "does not add selected user to current user's friend list if it is done by a different user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      charlie = Fabricate(:user)
      set_current_user(alice)
      post :create, friend_id: bob.id, user: charlie
      expect(charlie.reload.friends).not_to include(bob)
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 3 }
    end

    it "removes the relationship" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(bob)
      friendship = Fabricate(:friendship, user_id: bob.id, friend_id: alice.id)
      delete :destroy, id: friendship.id
      expect(bob.reload.friends.count).to eq(0)
    end

    it "does not remove the relationship for another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      charlie = Fabricate(:user)
      set_current_user(charlie)
      friendship = Fabricate(:friendship, user_id: bob.id, friend_id: alice.id)
      delete :destroy, id: friendship.id
      expect(bob.reload.friends.count).to eq(1)
    end
  end
end
