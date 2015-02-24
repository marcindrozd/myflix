class User < ActiveRecord::Base
  has_secure_password

  validates_presence_of :full_name, :email_address
  validates_uniqueness_of :email_address
end
