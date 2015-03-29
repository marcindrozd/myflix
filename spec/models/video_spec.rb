require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:large_cover) }
  it { should validate_presence_of(:small_cover) }
  it { should validate_presence_of(:video_url) }
  it { should have_many(:reviews).order('created_at desc') }

  describe ".search_by_title" do
    let(:small_cover) { File.open(File.join(Rails.root,'spec','support','videos', 'small_cover.png')) }
    let(:large_cover) { File.open(File.join(Rails.root,'spec','support','videos', 'large_cover.png')) }

    it "returns an empty array when no matches" do
      indiana_jones = Fabricate(:video, title: "Indiana Jones")
      futurama = Fabricate(:video, title: "Futurama")
      little_indian = Fabricate(:video, title: "Three little indians")
      expect(Video.search_by_title("hello")).to eq([])
    end

    it "returns an array with title if there is match" do
      indiana_jones = Fabricate(:video, title: "Indiana Jones")
      futurama = Fabricate(:video, title: "Futurama")
      little_indian = Fabricate(:video, title: "Three little indians")
      expect(Video.search_by_title("indiana")).to eq([indiana_jones])
    end

    it "returns an array with title if there is a partial match" do
      indiana_jones = Fabricate(:video, title: "Indiana Jones")
      futurama = Fabricate(:video, title: "Futurama")
      little_indian = Fabricate(:video, title: "Three little indians")
      expect(Video.search_by_title("uram")).to eq([futurama])
    end

    it "returns an array with all matching titles for multiple finds ordered by created date" do
      indiana_jones = Fabricate(:video, title: "Indiana Jones", created_at: 1.day.ago)
      futurama = Fabricate(:video, title: "Futurama")
      little_indian = Fabricate(:video, title: "Three little indians")
      expect(Video.search_by_title("india")).to eq([little_indian, indiana_jones])
    end

    it "returns an empty array when there is no input from the user" do
      indiana_jones = Fabricate(:video, title: "Indiana Jones", created_at: 1.day.ago)
      futurama = Fabricate(:video, title: "Futurama")
      little_indian = Fabricate(:video, title: "Three little indians")
      expect(Video.search_by_title("")).to eq([])
    end
  end

  describe "#rating" do
    it "returns 0 if no ratings" do
      video = Fabricate(:video)
      expect(video.rating).to eq('0')
    end

    it "returns average if there are ratings" do
      video = Fabricate(:video)
      Fabricate(:review, rating: 5, video: video)
      Fabricate(:review, rating: 1, video: video)
      expect(video.rating).to eq('3.0')
    end
  end
end
