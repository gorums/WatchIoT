class CreateProjectRolUserPerms < ActiveRecord::Migration
  def change
    create_table :project_rol_user_perms do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :project_rols_id

      t.timestamps null: false
    end
    add_index :project_rol_user_perms, :user_id
    add_index :project_rol_user_perms, :project_id
    add_index :project_rol_user_perms, :project_rols_id
  end
end
