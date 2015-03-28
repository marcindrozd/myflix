require 'spec_helper'

feature 'User registers', {js: true, vcr: true} do
  background do
    visit register_path
  end

  scenario "with valid information and valid credit card" do
    fill_in_valid_information
    fill_in_valid_credit_card
    click_button "Sign Up"

    expect(page).to have_content("You have been registered successfully!")
  end

  scenario "with valid information and invalid credit card" do
    fill_in_valid_information
    fill_in_invalid_credit_card
    click_button "Sign Up"

    expect(page).to have_content("This card number looks invalid.")
  end

  scenario "with valid information and declined credit card" do
    fill_in_valid_information
    fill_in_declined_credit_card
    click_button "Sign Up"

    expect(page).to have_content("Your card was declined.")
  end

  scenario "with invalid information and valid credit card" do
    fill_in_invalid_information
    fill_in_valid_credit_card
    click_button "Sign Up"

    expect(page).to have_content("Please correct the below errors")
  end

  scenario "with invalid information and invalid credit card" do
    fill_in_invalid_information
    fill_in_invalid_credit_card
    click_button "Sign Up"

    expect(page).to have_content("This card number looks invalid.")
  end

  scenario "with invalid information and declined credit card" do
    fill_in_invalid_information
    fill_in_declined_credit_card
    click_button "Sign Up"

    expect(page).to have_content("Please correct the below errors")
  end
end

def fill_in_valid_information
  fill_in "Email address", with: "test@example.com"
  fill_in "Password", with: "password"
  fill_in "Full name", with: "John Doe"
end

def fill_in_valid_credit_card
  fill_in "Credit Card Number", with: "4242424242424242"
  fill_in "Security Code", with: "123"
  select "4 - April", from: "date_month"
  select "2017", from: "date_year"
end

def fill_in_invalid_credit_card
  fill_in "Credit Card Number", with: "123"
  fill_in "Security Code", with: "123"
  select "4 - April", from: "date_month"
  select "2017", from: "date_year"
end

def fill_in_declined_credit_card
  fill_in "Credit Card Number", with: "4000000000000002"
  fill_in "Security Code", with: "123"
  select "4 - April", from: "date_month"
  select "2017", from: "date_year"
end

def fill_in_invalid_information
  fill_in "Email address", with: "test@example.com"
end
