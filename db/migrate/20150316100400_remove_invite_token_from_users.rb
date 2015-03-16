class RemoveInviteTokenFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :invite_token
  end
end
