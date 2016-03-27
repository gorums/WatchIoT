class CreateVerifyClients < ActiveRecord::Migration
  def change
    create_table :verify_clients do |t|
      t.string :token
      t.string :data
      t.string :concept
      t.references :user

      t.timestamps null: false
    end

    add_index :verify_clients, :token
    add_index :verify_clients, :concept
    add_index :verify_clients, :user_id
  end
end
