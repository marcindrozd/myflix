require 'spec_helper'

feature "Using My Queue feature" do
  scenario "user signs in and adds video to my queue" do

    comedy = Category.create(name: "comedy")
    futurama = Fabricate(:video, title: "Futurama", category: comedy)
    family_guy = Fabricate(:video, title: "Family Guy", category: comedy)
    south_park = Fabricate(:video, title: "South Park", category: comedy)

    sign_in

    add_to_queue(futurama)

    confirm_if_video_in_queue(futurama)

    check_if_link_not_visible(futurama, '+ My Queue')

    add_to_queue(family_guy)
    add_to_queue(south_park)

    update_list_order_for(futurama, 3)
    update_list_order_for(family_guy, 1)
    update_list_order_for(south_park, 2)

    confirm_updated_list_order_for(family_guy, 1)
    confirm_updated_list_order_for(south_park, 2)
    confirm_updated_list_order_for(futurama, 3)
  end
end

def add_to_queue(video)
  visit home_path
  find("a[href='/videos/#{video.id}']").click
  click_link('+ My Queue')
end

def update_list_order_for(video, list_order)
  within(:xpath, "//tr[contains(.,'#{video.title}')]") do
    fill_in("queue_items[][list_order]", with: list_order)
  end
end

def confirm_updated_list_order_for(video, list_order)
  expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(list_order.to_s)
end

def check_if_link_not_visible(video, link_text)
  visit("/videos/#{video.id}")
  expect(page).not_to have_content(link_text)
end

def confirm_if_video_in_queue(video)
  expect(page).to have_content('List Order')
  expect(page).to have_content(video.title)
end
