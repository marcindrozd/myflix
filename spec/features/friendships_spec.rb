require 'spec_helper'

feature "Using following feature" do
  scenario "user signs in and follows another user" do
    comedy = Category.create(name: "comedy")
    futurama = Fabricate(:video, title: "Futurama", category: comedy)
    alice = Fabricate(:user)
    bob = Fabricate(:user)
    Fabricate(:review, video: futurama, user: bob)

    sign_in(alice)

    visit home_path
    click_video_title(futurama)

    click_link(bob.full_name)
    click_link('Follow')

    visit people_path
    expect(page).to have_content(bob.full_name)

    remove_user_from_following(bob)
    expect(page).not_to have_content(bob.full_name)
  end
end

def remove_user_from_following(user)
  within(:xpath, "//tr[contains(.,'#{user.full_name}')]") do
    find("a[data-method='delete']").click
  end
end
