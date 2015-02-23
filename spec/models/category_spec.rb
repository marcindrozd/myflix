require 'spec_helper'
require 'shoulda/matchers'

describe Category do
  it "saves itself" do
    category = Category.new(name: "Adventure")
    category.save

    expect(Category.first).to eq(category)
  end

  it "has many videos" do
    category = Category.new(name: "Adventure")
    indiana = Video.create(title: "Indiana Jones",
                      description: "This is a great movie",
                      small_img_url: "/indiana_sm.jpg",
                      large_img_url: "/indiana_lg.jpg")
    futurama = Video.create(title: "Futurama",
                      description: "This is an awesome show",
                      small_img_url: "/futurama_sm.jpg",
                      large_img_url: "/futurama_lg.jpg")
    category.videos << indiana
    category.videos << futurama
    category.save
    expect(Category.first.videos).to eq([futurama, indiana])
  end

  it { should have_many(:videos) }
end
