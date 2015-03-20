Fabricator(:video) do
  title { Faker::Company.name }
  description { Faker::Lorem.paragraph }
  # small_cover { File.open(File.join(Rails.root,'spec','support','videos', 'small_cover.png')) }
  small_cover { Rack::Test::UploadedFile.new(File.join(Rails.root,'spec','support','videos', 'small_cover.png')) }
  large_cover { Rack::Test::UploadedFile.new(File.join(Rails.root,'spec','support','videos', 'large_cover.png')) }
end
