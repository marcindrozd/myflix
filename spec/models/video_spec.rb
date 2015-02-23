require 'spec_helper'
require 'shoulda/matchers'

describe Video do
  it "saves itself" do
    video = Video.new(title: "Futurama",
                      description: "This is an awesome show",
                      small_img_url: "/futurama_sm.jpg",
                      large_img_url: "/futurama_lg.jpg")
    video.save
    expect(Video.first).to eq(video)
  end

  it "belongs to a category" do
    video = Video.new(title: "Futurama",
                      description: "This is an awesome show",
                      small_img_url: "/futurama_sm.jpg",
                      large_img_url: "/futurama_lg.jpg")
    category = Category.new(name: "Comedy")
    video.category = category
    video.save

    expect(Video.first.category).to eq(category)
  end

  it "requires a title" do
    video = Video.create(title: "", description: "Fun movie!")
    expect(Video.first).to eq(nil)
    expect(Video.count).to eq(0)
  end

  it "requires a description" do
    video = Video.create(title: "Futurama", description: "")
    expect(Video.first).to eq(nil)
    expect(Video.count).to eq(0)
  end

  it { should belong_to(:category) }
end
