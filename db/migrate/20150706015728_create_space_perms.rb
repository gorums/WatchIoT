class CreateSpacePerms < ActiveRecord::Migration
  def change
    create_table :space_perms do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end
    add_index :space_perms, :name
  end
end
