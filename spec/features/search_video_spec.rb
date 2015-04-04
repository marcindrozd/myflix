require 'spec_helper'

feature "Searching for video" do
  scenario "user signs in and is searching for video" do
    comedy = Category.create(name: "comedy")
    futurama = Fabricate(:video, title: "Futurama", category: comedy)
    alice = Fabricate(:user)

    sign_in(alice)

    visit home_path
    fill_in 'video', with: "futu"
    click_button 'Search'
    visit "/videos/#{futurama.id}"
    expect(page).to have_content("Futurama")
  end
end
