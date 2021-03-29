class RenameProductAccountingId < ActiveRecord::Migration[5.2]
  def change
    rename_column :products, :accounting_id, :tripletex_id
  end
end
