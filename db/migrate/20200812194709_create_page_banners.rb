class CreatePageBanners < ActiveRecord::Migration[5.2]
  def change
    create_table :page_banners do |t|
      t.json :photo_data
      t.references :page, foreign_key: true
      t.integer :position
      t.json :imgix_photo_data

      t.timestamps
    end
  end
end
