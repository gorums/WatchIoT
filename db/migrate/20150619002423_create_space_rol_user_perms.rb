class CreateSpaceRolUserPerms < ActiveRecord::Migration
  def change
    create_table :space_rol_user_perms do |t|
      t.integer :id_user
      t.integer :id_space

      t.timestamps null: false
    end
  end
end
