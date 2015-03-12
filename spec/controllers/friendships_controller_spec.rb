require 'spec_helper'

describe FriendshipsController do
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
