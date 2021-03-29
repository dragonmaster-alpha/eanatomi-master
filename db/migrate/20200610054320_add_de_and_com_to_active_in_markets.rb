class AddDeAndComToActiveInMarkets < ActiveRecord::Migration[5.2]
  def change
    add_column :active_in_markets, :de, :boolean
    add_column :active_in_markets, :com, :boolean
  end
end
