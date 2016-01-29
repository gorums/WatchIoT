class CreateVerifyClients < ActiveRecord::Migration
  def change
    create_table :verify_clients do |t|
      t.string :token
      t.string :data
      t.references :user
    end

    add_index :verify_clients, :user_id
    add_index :verify_clients, :token
  end
end
