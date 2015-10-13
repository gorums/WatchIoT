class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :email
      t.boolean :principal, default: false
      t.references :user

      t.timestamps null: false
    end

    add_index :emails, :email
    add_index :emails, :user_id
  end
end
