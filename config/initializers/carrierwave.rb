CarrierWave.configure do |config|
  if Rails.env.development? || Rails.env.staging?
    config.storage = :fog
    config.fog_directory = ENV['S3_MYFLIX_STG_DIRECTORY']
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['S3_MYFLIX_STG_ACCESS_KEY'],
      aws_secret_access_key: ENV['S3_MYFLIX_STG_SECRET_ACCESS_KEY'],
      region: ENV['S3_MYFLIX_STG_REGION'],
    }
  elsif Rails.env.production?
    config.storage = :fog
    config.fog_directory = ENV['S3_MYFLIX_DIRECTORY']
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['S3_MYFLIX_ACCESS_KEY'],
      aws_secret_access_key: ENV['S3_MYFLIX_SECRET_ACCESS_KEY'],
      region: ENV['S3_MYFLIX_REGION'],
    }
  else
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"
  end
end
