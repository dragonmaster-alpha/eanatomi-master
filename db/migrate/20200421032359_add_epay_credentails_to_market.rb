class AddEpayCredentailsToMarket < ActiveRecord::Migration[5.2]
  def change
    add_column :markets, :epay_md5_key, :string
    add_column :markets, :epay_merchant_number, :string
  end
end
