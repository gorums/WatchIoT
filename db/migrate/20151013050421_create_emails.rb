##
# Email model
#
class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :email, limit: 35
      t.boolean :checked, default: false
      t.boolean :primary, default: false
      t.references :user

      t.timestamps null: false
    end

    add_index :emails, :email
    add_index :emails, :user_id
  end
end
