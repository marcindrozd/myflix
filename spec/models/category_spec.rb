require 'spec_helper'

describe Category do
  it { should have_many(:videos) }

  describe "#recent_videos" do
    it "returns all videos if there is less than 6 videos in category" do
      category = Category.create(name: "Blockbusters")

      indiana_jones = Fabricate(:video, title: "Indiana Jones", category: category, created_at: 3.days.ago)
      futurama = Fabricate(:video, title: "Futurama", category: category, created_at: 4.days.ago)
      avengers = Fabricate(:video, title: "Avengers", category: category)

      expect(category.recent_videos).to eq([avengers, indiana_jones, futurama])
    end

    it "shows 6 recent videos ordered by created date descending" do
      category = Category.create(name: "Blockbusters")

      indiana_jones = Fabricate(:video, title: "Indiana Jones", category: category, created_at: 3.days.ago)
      futurama = Fabricate(:video, title: "Futurama", category: category, created_at: 4.days.ago)
      avengers = Fabricate(:video, title: "Avengers", category: category)
      south_park = Fabricate(:video, title: "South Park", category: category, created_at: 2.days.ago)
      family_guy = Fabricate(:video, title: "Family Guy", category: category)
      ghostbusters = Fabricate(:video, title: "Ghostbusters", category: category, created_at: 1.day.ago)
      titanic = Fabricate(:video, title: "Titanic", category: category)

      expect(category.recent_videos).to eq([titanic, family_guy, avengers, ghostbusters, south_park, indiana_jones])
    end

    it "returns an empty array when category has no videos" do
      category = Category.create(name: "Blockbusters")
      other_category = Category.create(name: "Comedy")

      indiana_jones = Fabricate(:video, title: "Indiana Jones", category: category, created_at: 3.days.ago)
      futurama = Fabricate(:video, title: "Futurama", category: category, created_at: 4.days.ago)
      avengers = Fabricate(:video, title: "Avengers", category: category)
      south_park = Fabricate(:video, title: "South Park", category: category, created_at: 2.days.ago)
      family_guy = Fabricate(:video, title: "Family Guy", category: category)
      ghostbusters = Fabricate(:video, title: "Ghostbusters", category: category, created_at: 1.day.ago)
      titanic = Fabricate(:video, title: "Titanic", category: category)

      expect(other_category.recent_videos).to eq([])
    end
  end
end
