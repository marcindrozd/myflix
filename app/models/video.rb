class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order "created_at desc" }
  validates_presence_of :title, :description

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  def self.search_by_title(search_title)
    return [] if search_title.blank?
    where("lower(title) like ?", "%" + search_title.downcase + "%").order("created_at DESC")
  end
end
