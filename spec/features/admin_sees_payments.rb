require 'spec_helper'

feature "Admin sees payments page" do
  background do
    alice = Fabricate(:user, email_address: "alice@example.com", full_name: "Alice Wonderland")
    payment = Fabricate(:payment, user: alice, amount: 999)
  end

  scenario "admin views the page" do
    sign_in(Fabricate(:admin))
    visit admin_payments_path
    expect(page).to have_content("$9.99")
    expect(page).to have_content("Alice Wonderland")
    expect(page).to have_content("alice@example.com")
  end

  scenario "regular user is not allowed to see the page" do
    sign_in(Fabricate(:user))
    visit admin_payments_path
    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content("Alice Wonderland")
    expect(page).to have_content("You are not authorized to do that!")
  end
end
