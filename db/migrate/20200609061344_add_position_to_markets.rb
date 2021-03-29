class AddPositionToMarkets < ActiveRecord::Migration[5.2]
  def change
    add_column :markets, :position, :integer
  end
end
