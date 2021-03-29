class AddMegamenuTypeToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :megamenu_type, :string
  end
end
