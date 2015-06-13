class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login
      t.string :passwd
      t.timestamp :regiter
      t.string :email

      t.timestamps null: false
    end
  end
end
