class CreateCategoryMegaimages < ActiveRecord::Migration[5.2]
  def change
    create_table :category_megaimages do |t|
      t.json :photodata
      t.references :category, foreign_key: true
      t.integer :position
      t.json :imgix_photo_data
      t.text :mega_type
      t.string :url

      t.timestamps
    end
  end
end
