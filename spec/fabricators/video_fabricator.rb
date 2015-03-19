Fabricator(:video) do
  title { Faker::Company.name }
  description { Faker::Lorem.paragraph }
  large_cover { Faker::Lorem.word }
  small_cover { Faker::Lorem.word }
end
