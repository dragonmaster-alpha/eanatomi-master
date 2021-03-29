class AddRequireVatNumberToMarkets < ActiveRecord::Migration[5.2]
  def change
    add_column :markets, :require_vat_number, :boolean
  end
end
