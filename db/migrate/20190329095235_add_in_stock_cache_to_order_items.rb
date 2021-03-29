class AddInStockCacheToOrderItems < ActiveRecord::Migration[5.2]
  def change
    add_column :order_items, :in_stock_cache, :boolean
  end
end
