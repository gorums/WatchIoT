##
# Space model
#
class CreateSpaces < ActiveRecord::Migration
  def change
    create_table :spaces do |t|
      t.string :name, length: 25
      t.text :description
      t.references :user
      t.integer :user_owner_id

      t.timestamps null: false
    end

    add_index :spaces, :name
    add_index :spaces, :user_id
    add_index :spaces, :user_owner_id
  end
end
