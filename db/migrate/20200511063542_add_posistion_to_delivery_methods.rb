class AddPosistionToDeliveryMethods < ActiveRecord::Migration[5.2]
  def change
    add_column :delivery_methods, :position, :integer
  end
end
