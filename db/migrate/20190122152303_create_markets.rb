class CreateMarkets < ActiveRecord::Migration[5.0]
  def change
    create_table :markets do |t|
      t.string :key, index: true

      t.string :locale
      t.string :currency
      t.string :country
      t.string :country_code
      t.string :domain, index: true
      t.string :timezone
      t.decimal :rate
      t.decimal :vat
      t.decimal :clearance_fee
      t.string :analytics_id
      t.string :delivery_sku
      t.string :gift_card_sku
      t.string :delivery_id
      t.string :gift_card_id
      t.boolean :customs_invoice
      t.string :google_site_verification
      t.string :google_merchant_id
      t.string :phone_prefix
      t.boolean :free_shipping
      t.boolean :eu
      t.boolean :active
      t.string :accounting_class
      t.string :shipping_provider
      t.string :couriers, array: true
      t.boolean :choose_servicepoint
      t.boolean :notice
      t.string :blog_url
      t.string :warehouse

      t.timestamps
    end
  end
end
