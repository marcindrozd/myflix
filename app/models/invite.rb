class Invite < ActiveRecord::Base
  belongs_to :inviter, class_name: "User"
  validates_presence_of :friend_name, :friend_email, :message
end
