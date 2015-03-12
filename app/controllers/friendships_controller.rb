class FriendshipsController < ApplicationController
  before_action :require_user

  def index
    @friendships = current_user.friendships
  end

  def create
    @friend = User.find(params[:friend_id])

    unless current_user.friends.include?(@friend) || current_user == @friend
      Friendship.create(user: current_user, friend: @friend)
    end

    redirect_to people_path
  end

  def destroy
    friendship = Friendship.find(params[:id])

    if friendship.user == current_user
      friendship.destroy
      redirect_to people_path
    else
      flash[:danger] = "You are not allowed to do that!"
      redirect_to root_path
    end
  end
end
