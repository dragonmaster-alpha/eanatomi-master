class DropProductStocks < ActiveRecord::Migration[5.2]
  def change
    drop_table :product_stocks
  end
end
