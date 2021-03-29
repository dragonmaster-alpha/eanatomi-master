class CreateApiLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :api_logs do |t|
      t.string :service
      t.string :url
      t.string :method
      t.string :response_code
      t.text :response_body
      t.text :request_body

      t.timestamps

      t.index :service
    end
  end
end
