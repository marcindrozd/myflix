require 'spec_helper'

feature "Sending invitations" do
  scenario "user sends invitation to friend, friend opens the email and registers", { js: true, vcr: true } do
    bob = Fabricate(:user, full_name: "Bob Robertson")
    clear_emails

    sign_in(bob)
    click_on("Welcome, #{bob.full_name}")
    send_invitation_to_friend("Kim Possible", "kim@example.com")
    click_on("Welcome, #{bob.full_name}")
    sign_out

    open_link_from_email
    sign_up_with_email_invitation
    check_if_user_added_to_following("Bob Robertson")
    click_on("Welcome, Kim Possible")
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

def open_link_from_email
  open_email("kim@example.com")
  expect(current_email).to have_content("You have been invited to join MyFlix")
  current_email.click_link("Join MyFlix")
end

def sign_up_with_email_invitation
  fill_in("Password", with: "password")
  fill_in("Full name", with: "Kim Possible")
  fill_in("Credit Card Number", with: "4242424242424242")
  fill_in("Security Code", with: "123")
  select("4 - April", from: "date_month")
  select("2017", from: "date_year")
  click_button("Sign Up")
  expect(page).to have_content("Welcome, Kim Possible")
end

def check_if_user_added_to_following(user)
  click_link "People"
  expect(page).to have_content(user)
end
