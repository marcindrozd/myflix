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
end
