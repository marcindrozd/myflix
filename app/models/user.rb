class User < ActiveRecord::Base
  has_secure_password
  has_many :queue_items, -> { order :list_order }
  has_many :reviews, -> { order created_at: :desc }

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
end
