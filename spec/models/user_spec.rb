require 'spec_helper'

describe User do
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:email_address) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email_address) }
  it { should have_many(:queue_items).order(:list_order) }
  it { should have_many(:reviews).order(created_at: :desc) }
  it { should have_many(:friendships) }
  it { should have_many(:friends).through(:friendships) }
  it { should have_many(:followers).through(:inverse_friendships) }
  it { should have_many(:invites) }

  describe "#recalculate_order" do
    it "updates the order of videos in user's queue when a video to always start with 1" do
      bob = Fabricate(:user)
      queue_item1 = Fabricate(:queue_item, user: bob, list_order: 2)
      queue_item2 = Fabricate(:queue_item, user: bob, list_order: 3)
      bob.recalculate_order
      expect(queue_item1.reload.list_order).to eq(1)
      expect(queue_item2.reload.list_order).to eq(2)
    end
  end

  describe "#not_in_queue" do
    it "returns true if video is not in user's queue" do
      bob = Fabricate(:user)
      video = Fabricate(:video)
      expect(bob.not_in_queue?(video)).to be_truthy
    end

    it "returns false if video is in user's queue" do
      bob = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video, user: bob)
      expect(bob.not_in_queue?(video)).to be_falsey
    end
  end

  describe "#follow" do
    it "adds selected user to friends" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      alice.follow(bob)
      expect(alice.friends).to include(bob)
    end

    it "does not add current user to friends" do
      alice = Fabricate(:user)
      alice.follow(alice)
      expect(alice.friends).not_to include(alice)
    end
  end
end
