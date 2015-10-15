class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :api_key
    end

    add_index :api_keys, :api_key, unique: true
  end
end
