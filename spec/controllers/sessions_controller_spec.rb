require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "redirects to home path if logged in" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end

    it "renders new template if not logged in" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST create" do
    context "valid credentials" do
      let(:bob) { Fabricate(:user) }

      before do
        post :create, session: { email_address: bob.email_address, password: bob.password }
      end

      it "logs the user in" do
        expect(session[:user_id]).to eq(bob.id)
      end

      it "redirects to home page" do
        expect(response).to redirect_to home_path
      end

      it "flashes success message" do
        expect(flash[:success]).not_to be_blank
      end
    end

    context "invalid credentials" do
      let(:joe) { Fabricate(:user) }

      before do
        post :create, session: { email_address: joe.email_address, password: "wrong password" }
      end

      it "does not log the user in" do
        expect(session[:user_id]).not_to eq(joe.id)
      end

      it "renders :new template" do
        expect(response).to render_template :new
      end

      it "flashes error message" do
        expect(flash[:danger]).not_to be_blank
      end
    end
  end

  describe "DELETE destroy" do
    before do
      session[:user_id] = Fabricate(:user).id
      delete :destroy
    end

    it "removes the user.id from session" do
      expect(session[:user_id]).to be(nil)
    end

    it "redirects to root path" do
      expect(response).to redirect_to root_path
    end
  end
end
