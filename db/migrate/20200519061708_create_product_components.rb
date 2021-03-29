class CreateProductComponents < ActiveRecord::Migration[5.2]
  def change
    create_table :product_components do |t|
      t.integer :component_id
      t.integer :owner_id

      t.index :component_id
      t.index :owner_id

      t.timestamps
    end
  end
end
