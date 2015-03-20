class LargeCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process resize_to_fill: [665, 375]

  def default_url(*args)
    "https://md-myflix.s3.amazonaws.com/uploads/default_large.png"
  end
end
