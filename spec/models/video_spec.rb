require 'spec_helper'

describe Video do
  it "saves itself" do
    video = Video.new(title: "Futurama",
                      description: "This is an awesome show",
                      small_img_url: "/futurama_sm.jpg",
                      large_img_url: "/futurama_lg.jpg")
    video.save
    expect(video.title).to eq("Futurama")
    expect(video.description).to eq("This is an awesome show")
    expect(video.small_img_url).to eq("/futurama_sm.jpg")
    expect(video.large_img_url).to eq("/futurama_lg.jpg")
  end
end
