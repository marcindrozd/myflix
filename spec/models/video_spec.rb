require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:large_cover) }
  it { should validate_presence_of(:small_cover) }
  it { should have_many(:reviews).order('created_at desc')}

  describe ".search_by_title" do
    let(:small_cover) { File.open(File.join(Rails.root,'spec','support','videos', 'small_cover.png')) }
    let(:large_cover) { File.open(File.join(Rails.root,'spec','support','videos', 'large_cover.png')) }

    it "returns an empty array when no matches" do
      indiana_jones = Video.create(title: "Indiana Jones", description: "A great adventure", small_cover: small_cover, large_cover: large_cover)
      futurama = Video.create(title: "Futurama", description: "This is a space show", small_cover: small_cover, large_cover: large_cover)
      little_indian = Video.create(title: "Three little indians", description: "A comedy show", small_cover: small_cover, large_cover: large_cover)
      expect(Video.search_by_title("hello")).to eq([])
    end

    it "returns an array with title if there is match" do
      indiana_jones = Video.create(title: "Indiana Jones", description: "A great adventure", small_cover: small_cover, large_cover: large_cover)
      futurama = Video.create(title: "Futurama", description: "This is a space show", small_cover: small_cover, large_cover: large_cover)
      little_indian = Video.create(title: "Three little indians", description: "A comedy show", small_cover: small_cover, large_cover: large_cover)
      expect(Video.search_by_title("indiana")).to eq([indiana_jones])
    end

    it "returns an array with title if there is a partial match" do
      indiana_jones = Video.create(title: "Indiana Jones", description: "A great adventure", small_cover: small_cover, large_cover: large_cover)
      futurama = Video.create(title: "Futurama", description: "This is a space show", small_cover: small_cover, large_cover: large_cover)
      little_indian = Video.create(title: "Three little indians", description: "A comedy show", small_cover: small_cover, large_cover: large_cover)
      expect(Video.search_by_title("uram")).to eq([futurama])
    end

    it "returns an array with all matching titles for multiple finds ordered by created date" do
      indiana_jones = Video.create(title: "Indiana Jones", description: "A great adventure", small_cover: small_cover, large_cover: large_cover, created_at: 1.day.ago)
      futurama = Video.create(title: "Futurama", description: "This is a space show", small_cover: small_cover, large_cover: large_cover)
      little_indian = Video.create(title: "Three little indians", description: "A comedy show", small_cover: small_cover, large_cover: large_cover)
      expect(Video.search_by_title("india")).to eq([little_indian, indiana_jones])
    end

    it "returns an empty array when there is no input from the user" do
      indiana_jones = Video.create(title: "Indiana Jones", description: "A great adventure", small_cover: small_cover, large_cover: large_cover, created_at: 1.day.ago)
      futurama = Video.create(title: "Futurama", description: "This is a space show", small_cover: small_cover, large_cover: large_cover)
      little_indian = Video.create(title: "Three little indians", description: "A comedy show", small_cover: small_cover, large_cover: large_cover)
      expect(Video.search_by_title("")).to eq([])
    end
  end
end
