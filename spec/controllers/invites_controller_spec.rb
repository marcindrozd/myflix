require 'spec_helper'

describe InvitesController do
  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end

    it "sets @invitation variable" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_present
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end

    context "with valid data" do
      let(:bob) { Fabricate(:user) }

      before do
        UserMailer.deliveries.clear
        set_current_user(bob)
        post :create, invite: { friend_name: "Alice Wonderland",
                      friend_email: "alice@example.com",
                      message: "hi Alice! Please check this site!" }
      end

      it "redirects to new invitation path" do
        expect(response).to redirect_to new_invite_path
      end

      it "creats new invitation" do
        expect(Invite.count).to eq(1)
      end

      it "creates new invitation associated with current user" do
        expect(Invite.first.inviter).to eq(bob)
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
        expect(UserMailer.deliveries.last.body).to include(Invite.first.invite_token)
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
        post :create, invite: { friend_name: "Alice",
                      friend_email: "",
                      message: "" }
      end

      it { is_expected.to render_template :new }
      it { is_expected.to set_flash.now[:danger] }

      it "does not send email" do
        expect(UserMailer.deliveries).to be_empty
      end
    end
  end
end
