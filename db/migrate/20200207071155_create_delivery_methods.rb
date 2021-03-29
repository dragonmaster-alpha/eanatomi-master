class CreateDeliveryMethods < ActiveRecord::Migration[5.2]
  def change
    create_table :delivery_methods do |t|
      t.references :market, foreign_key: true
      t.string :key
      t.decimal :cost
      t.string :availability, array: true
      t.string :couriers, array: true

      t.timestamps
    end
  end
end
