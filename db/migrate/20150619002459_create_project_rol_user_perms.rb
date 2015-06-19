class CreateProjectRolUserPerms < ActiveRecord::Migration
  def change
    create_table :project_rol_user_perms do |t|
      t.integer :id_user
      t.integer :id_project

      t.timestamps null: false
    end
  end
end
