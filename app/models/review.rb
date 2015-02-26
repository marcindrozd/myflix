class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates_presence_of :content, :rating

  def self.average(video)
    return "0" if video.reviews.count == 0
    video.reviews.average(:rating)
  end
end
