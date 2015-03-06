class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  validates_numericality_of :list_order, { only_integer: true }

  def video_rating
    review = Review.where(user: user, video: video).first
    review.rating if review
  end

  def video_rating=(new_rating)
    review = Review.where(user: user, video: video).first
    if review
      review.update_column(:rating, new_rating)
    else
      review = Review.new(user: user, video: video, rating: new_rating)
      review.save(validate: false)
    end
  end

  def video_category
    video.category.name
  end
end
