Fabricator(:user) do
  full_name { Faker::Name.name }
  email_address { Faker::Internet.email }
  password { "password" }
  admin { false }
end

Fabricator(:admin, from: :user) do
  admin { true }
end
