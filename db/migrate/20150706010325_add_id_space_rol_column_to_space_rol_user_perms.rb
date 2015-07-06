class AddIdSpaceRolColumnToSpaceRolUserPerms < ActiveRecord::Migration
  def change
    add_column :space_rol_user_perms, :id_space_rols, :integer
  end
end
