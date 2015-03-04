require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items variable for authenticated user" do
      bob = Fabricate(:user)
      set_current_user(bob)
      queue_item1 = Fabricate(:queue_item, user: bob)
      queue_item2 = Fabricate(:queue_item, user: bob)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    it "redirects to my_queue site for signed in user" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to(my_queue_path)
    end

    it "creates a new queue item in queue items" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it "creates a new queue item for selected video" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end

    it "creates a new queue item for current user" do
      bob = Fabricate(:user)
      set_current_user(bob)
      video = Fabricate(:video)
      post :create, video_id: video.id, user_id: bob.id
      expect(QueueItem.first.user).to eq(bob)
    end

    it "creates a new item with the next available order" do
      bob = Fabricate(:user)
      set_current_user(bob)
      video = Fabricate(:video)
      queue_item1 = Fabricate(:queue_item, user: bob)
      post :create, video_id: video.id, user_id: bob.id
      expect(QueueItem.last.list_order).to eq(2)
    end

    it "creates a new item with order 1 if no items in the list" do
      bob = Fabricate(:user)
      set_current_user(bob)
      video = Fabricate(:video)
      post :create, video_id: video.id, user_id: bob.id
      expect(QueueItem.last.list_order).to eq(1)
    end

    it "does not create a new item if item is already in the queue" do
      bob = Fabricate(:user)
      set_current_user(bob)
      video = Fabricate(:video)
      queue_item1 = Fabricate(:queue_item, user: bob, video: video)
      post :create, video_id: video.id, user_id: bob.id
      expect(QueueItem.count).to eq(1)
    end

    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: Fabricate(:queue_item).id }
    end

    it "redirects authenticated user to my queue site" do
      set_current_user
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item
      expect(response).to redirect_to my_queue_path
    end

    it "removes the video from the queue" do
      bob = Fabricate(:user)
      set_current_user(bob)
      queue_item = Fabricate(:queue_item, user: bob)
      delete :destroy, id: queue_item
      expect(QueueItem.count).to eq(0)
    end

    it "does not remove a video from other users queue" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(bob)
      queue_item = Fabricate(:queue_item, user: alice)
      delete :destroy, id: queue_item
      expect(QueueItem.count).to eq(1)
    end

    it "recalculates list order after an item was removed" do
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item1 = Fabricate(:queue_item, user: alice, list_order: 1)
      queue_item2 = Fabricate(:queue_item, user: alice, list_order: 2)
      delete :destroy, id: queue_item1
      expect(queue_item2.reload.list_order).to eq(1)
    end
  end

  describe "POST update_queue" do
    context "with valid data" do
      it "redirects to my_queue path" do
        alice = Fabricate(:user)
        set_current_user(alice)
        queue_item1 = Fabricate(:queue_item, list_order: 2)
        queue_item2 = Fabricate(:queue_item, list_order: 1)
        post :update_queue, queue_items: [{ id: queue_item1.id, list_order: 2 }, { id: queue_item2.id, list_order: 1 }]
        expect(response).to redirect_to my_queue_path
      end

      it "changes the order for queue items" do
        alice = Fabricate(:user)
        set_current_user(alice)
        queue_item1 = Fabricate(:queue_item, user: alice, list_order: 1)
        queue_item2 = Fabricate(:queue_item, user: alice, list_order: 2)
        post :update_queue, queue_items: [{ id: queue_item1.id, list_order: 2 }, { id: queue_item2.id, list_order: 1 }]
        expect(alice.queue_items).to eq([queue_item2, queue_item1])
      end

      it "recalculates the order for the remaining queue items" do
        alice = Fabricate(:user)
        set_current_user(alice)
        queue_item1 = Fabricate(:queue_item, user: alice, list_order: 1)
        queue_item2 = Fabricate(:queue_item, user: alice, list_order: 2)
        post :update_queue, queue_items: [{ id: queue_item1.id, list_order: 3 }, { id: queue_item2.id, list_order: 2 }]
        expect(queue_item1.reload.list_order).to eq(2)
        expect(queue_item2.reload.list_order).to eq(1)
      end

      it "does not allow updating the queue item for another user" do
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        set_current_user(alice)
        queue_item1 = Fabricate(:queue_item, user: alice, list_order: 1)
        queue_item2 = Fabricate(:queue_item, user: bob, list_order: 2)
        post :update_queue, queue_items: [{ id: queue_item1.id, list_order: 3 }, { id: queue_item2.id, list_order: 1 }]
        expect(queue_item2.reload.list_order).to eq(2)
      end
    end

    context "with invalid data" do
      it "redirects to my queue path" do
        alice = Fabricate(:user)
        set_current_user(alice)
        queue_item1 = Fabricate(:queue_item, user: alice, list_order: 2)
        queue_item2 = Fabricate(:queue_item, user: alice, list_order: 1)
        post :update_queue, queue_items: [{ id: queue_item1.id, list_order: 2 }, { id: queue_item2.id, list_order: 1.5 }]
        expect(response).to redirect_to my_queue_path
      end

      it "displays error message" do
        alice = Fabricate(:user)
        set_current_user(alice)
        queue_item1 = Fabricate(:queue_item, user: alice, list_order: 2)
        queue_item2 = Fabricate(:queue_item, user: alice, list_order: 1)
        post :update_queue, queue_items: [{ id: queue_item1.id, list_order: 2 }, { id: queue_item2.id, list_order: 1.5 }]
        expect(flash[:danger]).to be_present
      end

      it "does not update queue items" do
        alice = Fabricate(:user)
        set_current_user(alice)
        queue_item1 = Fabricate(:queue_item, user: alice, list_order: 2)
        queue_item2 = Fabricate(:queue_item, user: alice, list_order: 1)
        post :update_queue, queue_items: [{ id: queue_item1.id, list_order: 3 }, { id: queue_item2.id, list_order: 2 }]
        expect(queue_item1.reload.list_order).to eq(2)
      end
    end

    context "with unauthenticated user" do
      it_behaves_like "requires sign in" do
        let(:action) { post :update_queue }
      end
    end
  end
end
