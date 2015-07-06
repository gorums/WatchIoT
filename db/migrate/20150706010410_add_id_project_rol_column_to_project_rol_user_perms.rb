class AddIdProjectRolColumnToProjectRolUserPerms < ActiveRecord::Migration
  def change
    add_column :project_rol_user_perms, :id_project_rols, :integer
  end
end
