require 'spec_helper'

feature "Sending invitations" do
  scenario "user sends invitation to friend, friend opens the email and registers" do
    bob = Fabricate(:user, full_name: "Bob Robertson")
    clear_emails

    sign_in(bob)
    click_link("Invite a friend")

    fill_in("Friend's Name", with: "Kim Possible")
    fill_in("Friend's Email Address", with: "kim@example.com")
    click_button("Send Invitation")

    expect(page).to have_content("Invitation has been sent!")

    click_link "Sign Out"

    open_email("kim@example.com")
    expect(current_email).to have_content("You have been invited to join MyFlix")

    current_email.click_link("Join MyFlix")

    fill_in("Password", with: "password")
    fill_in("Full name", with: "Kim Possible")
    click_button("Sign Up")

    expect(page).to have_content("Welcome, Kim Possible")

    click_link "People"
    expect(page).to have_content("Bob Robertson")
  end
end
