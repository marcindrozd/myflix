class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :inviter_id
      t.string :friend_name, :friend_email, :invite_token
      t.text :message

      t.timestamps
    end
  end
end
