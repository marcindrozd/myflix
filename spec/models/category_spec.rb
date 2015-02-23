require 'spec_helper'

describe Category do
  it "saves itself" do
    category = Category.new(name: "Adventure")
    category.save

    expect(Category.first).to eq(category)
  end

  it "has many videos" do
    category = Category.new(name: "Adventure")
    video1 = Video.new(title: "Futurama",
                      description: "This is an awesome show",
                      small_img_url: "/futurama_sm.jpg",
                      large_img_url: "/futurama_lg.jpg")
    video2 = Video.new(title: "Indiana Jones",
                      description: "This is a great movie",
                      small_img_url: "/indiana_sm.jpg",
                      large_img_url: "/indiana_lg.jpg")
    video1.save
    video2.save
    category.videos << video1
    category.videos << video2
    category.save
    expect(Category.first.videos).to eq([video1, video2])
  end
end
