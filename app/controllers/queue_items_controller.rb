class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    QueueItem.create(video: video, user: current_user, list_order: next_list_item) unless queue_includes?(video)
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])

    queue_item.destroy if queue_item.user == current_user
    redirect_to my_queue_path
  end

  private

  def next_list_item
    current_user.queue_items.count + 1
  end

  def queue_includes?(video)
    current_user.queue_items.map(&:video).include?(video)
  end
end
