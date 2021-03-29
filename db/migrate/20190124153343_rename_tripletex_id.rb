class RenameTripletexId < ActiveRecord::Migration[5.2]
  def change
    rename_column :products, :tripletex_id, :accounting_id
  end
end
