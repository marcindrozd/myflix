require 'spec_helper'

describe QueueItem do
  describe "#video_title" do
    it "returns video title" do
      futurama = Fabricate(:video, title: "Futurama")
      item1 = Fabricate(:queue_item, video: futurama)
      expect(item1.video_title).to eq("Futurama")
    end
  end

  describe "#video_rating" do
    it "returns current user's rating of the video" do
      video = Fabricate(:video)
      bob = Fabricate(:user)
      review = Fabricate(:review, user: bob, video: video, rating: 4)
      item1 = Fabricate(:queue_item, video: video, user: bob)
      expect(item1.video_rating).to eq(4)
    end

    it "returns nil when there is no review" do
      video = Fabricate(:video)
      bob = Fabricate(:user)
      item1 = Fabricate(:queue_item, video: video, user: bob)
      expect(item1.video_rating).to eq(nil)
    end
  end

  describe "#video_category" do
    it "returns video category name" do
      category = Category.create(name: "comedy")
      video = Fabricate(:video, category: category)
      item1 = Fabricate(:queue_item, video: video)
      expect(item1.video_category).to eq("comedy")
    end
  end

  describe "#category" do
    it "returns category" do
      category = Category.create(name: "comedy")
      video = Fabricate(:video, category: category)
      item1 = Fabricate(:queue_item, video: video)
      expect(item1.category).to eq(category)
    end
  end
end
