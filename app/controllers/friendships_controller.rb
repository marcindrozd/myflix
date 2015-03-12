class FriendshipsController < ApplicationController
  before_action :require_user

  def destroy
    friendship = Friendship.find(params[:id])

    if friendship.user == current_user
      friendship.destroy
      redirect_to current_user
    else
      flash[:danger] = "You are not allowed to do that!"
      redirect_to root_path
    end
  end
end
