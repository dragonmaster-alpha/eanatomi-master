class AddEconomicIdToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :economic_id, :string
  end
end
