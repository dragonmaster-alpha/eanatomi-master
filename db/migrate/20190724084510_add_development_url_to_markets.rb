class AddDevelopmentUrlToMarkets < ActiveRecord::Migration[5.2]
  def change
    add_column :markets, :development_url, :string
  end
end
