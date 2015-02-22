class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.text :description
      t.float :rating
      t.string :small_img_url
      t.string :large_img_url

      t.timestamps
    end
  end
end
