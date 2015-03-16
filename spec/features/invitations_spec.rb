require 'spec_helper'

feature "Sending invitations" do
  scenario "user sends invitation to friend, friend opens the email and registers" do
    bob = Fabricate(:user, full_name: "Bob Robertson")
    clear_emails

    sign_in(bob)
    send_invitation_to_friend("Kim Possible", "kim@example.com")
    sign_out

    open_link_from_email
    sign_up_with_email_invitation
    check_if_user_added_to_following("Bob Robertson")
    sign_out

    sign_in(bob)
    check_if_user_added_to_following("Kim Possible")
  end

  scenario "friend accepts the invite and following works even if there was validation error" do
    bob = Fabricate(:user, full_name: "Bob Robertson")
    clear_emails

    sign_in(bob)
    send_invitation_to_friend("Kim Possible", "kim@example.com")
    sign_out

    try_sign_up_with_validation_error
    sign_up_with_email_invitation
    check_if_user_added_to_following("Bob Robertson")
    sign_out

    sign_in(bob)
    check_if_user_added_to_following("Kim Possible")
  end
end

def send_invitation_to_friend(user, email)
  click_link("Invite a friend")
  fill_in("Friend's Name", with: user)
  fill_in("Friend's Email Address", with: email)
  click_button("Send Invitation")
  expect(page).to have_content("Invitation has been sent!")
end

def try_sign_up_with_validation_error
  open_email("kim@example.com")
  expect(current_email).to have_content("You have been invited to join MyFlix")
  current_email.click_link("Join MyFlix")
  fill_in("Password", with: "")
  fill_in("Full name", with: "Kim Possible")
  click_button("Sign Up")
  expect(page).to have_content("can't be blank")
end

def open_link_from_email
  open_email("kim@example.com")
  expect(current_email).to have_content("You have been invited to join MyFlix")
  current_email.click_link("Join MyFlix")
end

def sign_up_with_email_invitation
  fill_in("Password", with: "password")
  fill_in("Full name", with: "Kim Possible")
  click_button("Sign Up")
  expect(page).to have_content("Welcome, Kim Possible")
end

def check_if_user_added_to_following(user)
  click_link "People"
  expect(page).to have_content(user)
end
