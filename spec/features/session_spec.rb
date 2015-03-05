require 'spec_helper'

feature "Signing in" do
  background do
    Fabricate(:user, email_address: "user@example.com", password: "password")
  end

  scenario "signs in with correct credentials" do
    visit('/sign_in')
    fill_in('Email address', :with => "user@example.com")
    fill_in('Password', :with => "password")
    click_button('Sign in')
    expect(page).to have_content('You are now logged in!')
  end

  scenario "does not sign in with incorrect credentials" do
    visit('/sign_in')
    fill_in('Email address', :with => "user@example.com")
    fill_in('Password', :with => "wrong_password")
    click_button('Sign in')
    expect(page).to have_content('There is something wrong with your username or password')
    expect(page).to have_content('Sign in')
  end
end
