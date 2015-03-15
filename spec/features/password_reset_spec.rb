require 'spec_helper'

feature "Using password reset feature" do
  scenario "user resets forgotten password" do
    bob = Fabricate(:user, password: "old_password", email_address: "bob@example.com")
    clear_emails

    visit root_path

    send_password_reset_email_to("bob@example.com")
    open_email_and_click_password_reset(bob, "bob@example.com")
    fill_in_new_password("new password")
    sign_in_with_new_password("bob@example.com", "new password")

    expect(page).to have_content("Welcome, #{bob.full_name}")
  end
end

def send_password_reset_email_to(email_address)
  click_link('Sign In')
  click_link('Forgot password?')
  fill_in('Email Address', with: email_address)
  click_button('Send Email')
end

def open_email_and_click_password_reset(user, email_address)
  open_email(email_address)
  expect(current_email).to have_content(user.full_name)
  current_email.click_link('Reset your password')
end

def fill_in_new_password(password)
  fill_in('New Password', with: password)
  click_button('Reset Password')
end

def sign_in_with_new_password(email, password)
  visit('/sign_in')
  fill_in('Email address', :with => "bob@example.com")
  fill_in('Password', :with => "new password")
  click_button('Sign in')
end
