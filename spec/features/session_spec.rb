require 'spec_helper'

feature "Signing in" do
  given(:bob) { Fabricate(:user) }

  scenario "signs in with correct credentials" do
    visit('/sign_in')
    fill_in('Email address', :with => bob.email_address)
    fill_in('Password', :with => bob.password)
    click_button('Sign in')
    expect(page).to have_content('You are now logged in!')
    expect(page).to have_content(bob.full_name)
  end

  scenario "does not sign in with incorrect credentials" do
    visit('/sign_in')
    fill_in('Email address', :with => "user@example.com")
    fill_in('Password', :with => "wrong_password")
    click_button('Sign in')
    expect(page).to have_content('There is something wrong with your username or password')
    expect(page).to have_content('Sign in')
  end

  scenario "does not sign in when account is inactive" do
    alice = Fabricate(:user, active: false)
    visit('/sign_in')
    fill_in('Email address', :with => alice.email_address)
    fill_in('Password', :with => alice.password)
    click_button('Sign in')
    expect(page).not_to have_content(alice.full_name)
    expect(page).to have_content("Your account has expired, please contact customer support.")
  end
end
