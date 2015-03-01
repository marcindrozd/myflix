class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def video_rating
    review = Review.where(user: user, video: video).first
    review.rating if review
  end

  def video_category
    video.category.name
  end
end
