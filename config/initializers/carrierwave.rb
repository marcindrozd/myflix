CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['S3_MYFLIX_ACCESS_KEY'],
    aws_secret_access_key: ENV['S3_MYFLIX_SECRET_ACCESS_KEY'],
    region: ENV['S3_MYFLIX_REGION'],
  }

  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"
  else
    config.storage = :fog
  end

  config.fog_directory = ENV['S3_MYFLIX_DIRECTORY']
end
