require 'spec_helper'

feature "admin adds a new video" do
  scenario "admin signs in and adds new video" do
    admin = Fabricate(:admin)
    comedy = Fabricate(:category, name: "Comedy")
    sign_in(admin)

    visit new_admin_video_path
    fill_in('Title', with: 'Futurama')
    select('Comedy', from: 'Category')
    fill_in('Description', with: 'A very funny show')
    attach_file('Large cover', 'spec/support/videos/large_cover.png')
    attach_file('Small cover', 'spec/support/videos/small_cover.png')
    fill_in('Video URL', with: 'http://www.example.com/video.mp4')
    click_button('Add Video')

    sign_out
    sign_in

    visit video_path(Video.first)
    expect(page).to have_xpath("//img[@src=\"#{Video.first.large_cover}\"]")
    expect(page).to have_selector("a[href='http://www.example.com/video.mp4']")
  end
end
