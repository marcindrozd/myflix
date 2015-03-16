Fabricator(:invite) do
  friend_name { Faker::Name.name }
  friend_email { Faker::Internet.email }
  message { Faker::Lorem.paragraph }
  invite_token { Faker::Lorem.word }
end
