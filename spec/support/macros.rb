def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def sign_in(a_user=nil)
  user = a_user || Fabricate(:user)
  visit('/sign_in')
  fill_in('Email address', :with => user.email_address)
  fill_in('Password', :with => user.password)
  click_button('Sign in')
end

def click_video_title(video)
  find("a[href='/videos/#{video.id}']").click
end

def sign_out
  click_link('Sign Out')
end
