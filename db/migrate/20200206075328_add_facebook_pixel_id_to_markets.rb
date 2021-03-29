class AddFacebookPixelIdToMarkets < ActiveRecord::Migration[5.2]
  def change
    add_column :markets, :facebook_pixel_id, :string
  end
end
