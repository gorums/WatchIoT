##
# Project model
#
class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name, length: 25
      t.text :description
      t.references :user
      t.references :space
      t.integer :user_owner_id

      t.timestamps null: false
    end

    add_index :projects, :name
    add_index :projects, :space_id
    add_index :projects, :user_id
    add_index :projects, :user_owner_id
  end
end
