class AddComponentIdsToOrderItems < ActiveRecord::Migration[5.2]
  def change
    add_column :order_items, :component_ids, :integer, array: true
  end
end
