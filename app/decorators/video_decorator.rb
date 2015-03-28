class VideoDecorator < Draper::Decorator
  delegate_all

  def review_rating
    if object.reviews.any?
      "#{Review.average(object)} / 5.0"
    else
      "No ratings yet"
    end
  end
end
