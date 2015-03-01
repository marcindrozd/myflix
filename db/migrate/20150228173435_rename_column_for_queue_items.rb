class RenameColumnForQueueItems < ActiveRecord::Migration
  def change
    rename_column :queue_items, :order, :list_order
  end
end
