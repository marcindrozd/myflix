class RemoveUnusedColumnsInVideos < ActiveRecord::Migration
  def change
    remove_column :videos, :rating
    remove_column :videos, :small_img_url
    remove_column :videos, :large_img_url
  end
end
