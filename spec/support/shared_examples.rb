shared_examples "requires sign in" do
  it "redirects to the sign in page" do
    session[:user_id] = nil
    action
    expect(response).to redirect_to root_path
  end
end

shared_examples "requires admin" do
  it "redirects to home path" do
    bob = Fabricate(:user)
    set_current_user(bob)
    get :new
    expect(response).to redirect_to home_path
  end

  it "flashes error message" do
    bob = Fabricate(:user)
    set_current_user(bob)
    get :new
    expect(flash[:danger]).to be_present
  end
end
