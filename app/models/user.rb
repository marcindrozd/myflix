class User < ActiveRecord::Base
  has_secure_password
  has_many :queue_items, -> { order :list_order }
  has_many :reviews, -> { order created_at: :desc }
  has_many :friendships
  has_many :friends, through: :friendships
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: :friend_id
  has_many :followers, through: :inverse_friendships, source: :user
  has_many :invites, foreign_key: :inviter_id

  validates_presence_of :full_name, :email_address
  validates_uniqueness_of :email_address

  def recalculate_order
    queue_items.each_with_index do |item, index|
      item.update_attributes(list_order: index + 1)
    end
  end

  def not_in_queue?(video)
    !queue_items.map(&:video_id).include?(video.id)
  end

  def can_follow?(another_user)
    !(friends.include?(another_user) || self == another_user)
  end

  def follow(another_user)
    friends << another_user if can_follow?(another_user)
  end

  def not_admin?
    !admin
  end
end
