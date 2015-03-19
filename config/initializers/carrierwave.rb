CarrierWave.configure do |config|
  config.storage = :fog
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['S3_MYFLIX_ACCESS_KEY'],
    aws_secret_access_key: ENV['S3_MYFLIX_SECRET_ACCESS_KEY'],
    region: ENV['S3_MYFLIX_REGION']
  }
  config.fog_directory = ENV['S3_MYFLIX_DIRECTORY']
end
