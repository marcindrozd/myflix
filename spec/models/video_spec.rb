require 'spec_helper'

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
end
