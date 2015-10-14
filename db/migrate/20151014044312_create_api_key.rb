class CreateApiKey < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :api_key
      t.references :user
    end

    add_index :api_keys, :api_key, unique: true
    add_index :api_keys, :user_id
  end
end
