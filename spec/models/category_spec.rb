require 'spec_helper'

describe Category do
  it { should have_many(:videos) }

  describe "#recent_videos" do
    it "returns all videos if there is less than 6 videos in category" do
      category = Category.create(name: "Blockbusters")
      small_cover = File.open(File.join(Rails.root,'spec','support','videos', 'small_cover.png'))
      large_cover = File.open(File.join(Rails.root,'spec','support','videos', 'large_cover.png'))

      indiana_jones = Video.create(title: "Indiana Jones", description: "A great adventure", small_cover: small_cover, large_cover: large_cover, category: category, created_at: 3.days.ago)
      futurama = Video.create(title: "Futurama", description: "This is a space show", small_cover: small_cover, large_cover: large_cover, category: category, created_at: 4.days.ago)
      avengers = Video.create(title: "Avengers", description: "Comic book battle", small_cover: small_cover, large_cover: large_cover, category: category)

      expect(category.recent_videos).to eq([avengers, indiana_jones, futurama])
    end

    it "shows 6 recent videos ordered by created date descending" do
      category = Category.create(name: "Blockbusters")
      small_cover = File.open(File.join(Rails.root,'spec','support','videos', 'small_cover.png'))
      large_cover = File.open(File.join(Rails.root,'spec','support','videos', 'large_cover.png'))

      indiana_jones = Video.create(title: "Indiana Jones", description: "A great adventure", small_cover: small_cover, large_cover: large_cover, category: category, created_at: 3.days.ago)
      futurama = Video.create(title: "Futurama", description: "This is a space show", small_cover: small_cover, large_cover: large_cover, category: category, created_at: 4.days.ago)
      avengers = Video.create(title: "Avengers", description: "Comic book battle", small_cover: small_cover, large_cover: large_cover, category: category)
      south_park = Video.create(title: "South Park", description: "Quiet mountain town", small_cover: small_cover, large_cover: large_cover, category: category, created_at: 2.days.ago)
      family_guy = Video.create(title: "Family Guy", description: "Great comedy", small_cover: small_cover, large_cover: large_cover, category: category)
      ghostbusters = Video.create(title: "Ghostbusters", description: "Who ya gonna call", small_cover: small_cover, large_cover: large_cover, category: category, created_at: 1.day.ago)
      titanic = Video.create(title: "Titanic", description: "Love story", small_cover: small_cover, large_cover: large_cover, category: category)

      expect(category.recent_videos).to eq([titanic, family_guy, avengers, ghostbusters, south_park, indiana_jones])
    end

    it "returns an empty array when category has no videos" do
      category = Category.create(name: "Blockbusters")
      other_category = Category.create(name: "Comedy")
      small_cover = File.open(File.join(Rails.root,'spec','support','videos', 'small_cover.png'))
      large_cover = File.open(File.join(Rails.root,'spec','support','videos', 'large_cover.png'))

      indiana_jones = Video.create(title: "Indiana Jones", description: "A great adventure", small_cover: small_cover, large_cover: large_cover, category: category, created_at: 3.days.ago)
      futurama = Video.create(title: "Futurama", description: "This is a space show", small_cover: small_cover, large_cover: large_cover, category: category, created_at: 4.days.ago)
      avengers = Video.create(title: "Avengers", description: "Comic book battle", small_cover: small_cover, large_cover: large_cover, category: category)
      south_park = Video.create(title: "South Park", description: "Quiet mountain town", small_cover: small_cover, large_cover: large_cover, category: category, created_at: 2.days.ago)
      family_guy = Video.create(title: "Family Guy", description: "Great comedy", small_cover: small_cover, large_cover: large_cover, category: category)
      ghostbusters = Video.create(title: "Ghostbusters", description: "Who ya gonna call", small_cover: small_cover, large_cover: large_cover, category: category, created_at: 1.day.ago)
      titanic = Video.create(title: "Titanic", description: "Love story", small_cover: small_cover, large_cover: large_cover, category: category)

      expect(other_category.recent_videos).to eq([])
    end
  end
end
