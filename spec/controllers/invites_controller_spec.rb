require 'spec_helper'

describe InvitesController do
  describe "POST create" do

    it_behaves_like "requires sign in" do
      let(:action) { post :create}
    end

    context "with valid data" do
      let(:bob) { Fabricate(:user) }

      before do
        UserMailer.deliveries.clear
        set_current_user(bob)
        post :create, friend_name: "Alice Wonderland",
                      friend_email: "alice@example.com",
                      message: "hi Alice! Please check this site!"
      end

      it "redirects to root path" do
        expect(response).to redirect_to home_path
      end

      it "generates token for existing user" do
        expect(bob.reload.invite_token).to be_present
      end

      it "sets the friend name, mail and message variables" do
        expect(assigns(:name)).to eq("Alice Wonderland")
        expect(assigns(:mail)).to eq("alice@example.com")
        expect(assigns(:message)).to eq("hi Alice! Please check this site!")
      end

      it "sends email" do
        expect(UserMailer.deliveries.count).to eq(1)
      end

      it "sends email to entered email address" do
        expect(UserMailer.deliveries.last.to).to eq(["alice@example.com"])
      end

      it "sends email with provided body message" do
        expect(UserMailer.deliveries.last.body).to include("hi Alice! Please check this site!")
      end

      it "sends email with generated token" do
        expect(UserMailer.deliveries.last.body).to include(bob.invite_token)
      end

      it "displays success message" do
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid data" do
      let(:bob) { Fabricate(:user) }

      before do
        UserMailer.deliveries.clear
        set_current_user(bob)
        post :create, friend_name: "Alice",
                      friend_email: "",
                      message: ""
      end

      it "renders new page" do
        expect(response).to render_template :new
      end

      it "displays error messages" do
        expect(flash[:danger]).to be_present
      end

      it "does not send email" do
        expect(UserMailer.deliveries.count).to eq(0)
      end
    end

    context "with user who already has an account" do
      let(:alice) { Fabricate(:user, email_address: "alice@example.com") }
      let(:bob) { Fabricate(:user) }

      before do
        UserMailer.deliveries.clear
        set_current_user(bob)
        post :create, friend_name: "Alice Wonderland",
                      friend_email: alice.email_address,
                      message: "hi Alice! Please check this site!"
      end

      it "does not send an email" do
        expect(UserMailer.deliveries.count).to eq(0)
      end

      it "displays message" do
        expect(flash[:danger]).to be_present
      end
    end

    context "with existing token" do
      it "does not generate a new token if one already exists" do
        old_token = "abcd"
        bob = Fabricate(:user, invite_token: old_token)
        set_current_user(bob)
        post :create, friend_name: "Alice Wonderland",
                      friend_email: "alice@example.com",
                      message: "hi Alice! Please check this site!"
        expect(bob.reload.invite_token).to eq(old_token)
      end
    end
  end
end
