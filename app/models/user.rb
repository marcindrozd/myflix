class User < ActiveRecord::Base
  has_secure_password
  has_many :queue_items, -> { order :list_order }

  validates_presence_of :full_name, :email_address
  validates_uniqueness_of :email_address
end
