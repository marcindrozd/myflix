Fabricator(:video) do
  title { Faker::Company.name }
  description { Faker::Lorem.paragraph }
end
