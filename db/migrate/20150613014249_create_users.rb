class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, limit: 15
      t.string :first_name, limit: 15
      t.string :last_name, limit: 15
      t.string :address
      t.string :country_code, limit: 3
      t.string :phone, limit: 15
      t.boolean :status, default: true
      t.boolean :receive_notif_last_new, default: true
      t.string :passwd
      t.string :passwd_salt
      t.string :auth_token
      t.integer :plan_id                                  #foreign key to table plan

      t.timestamps null: false
    end

    add_index :users, :username
    add_index :users, :status
    add_index :users, :plan_id
  end
end
