class Invite < ActiveRecord::Base
  belongs_to :inviter, class_name: "User"
  validates_presence_of :friend_name, :friend_email, :message

  def generate_token!
    update_column(:invite_token, SecureRandom.urlsafe_base64)
  end

  def remove_token!
    update_column(:invite_token, nil)
  end
end
