class CreateSpaceRolUserPerms < ActiveRecord::Migration
  def change
    create_table :space_rol_user_perms do |t|
      t.integer :user_id
      t.integer :space_id
      t.integer :space_rols_id

      t.timestamps null: false
    end
    add_index :space_rol_user_perms, :user_id
    add_index :space_rol_user_perms, :space_id
    add_index :space_rol_user_perms, :space_rols_id
  end
end
