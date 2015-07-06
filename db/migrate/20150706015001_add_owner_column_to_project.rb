class AddOwnerColumnToProject < ActiveRecord::Migration
  def change
    add_column :projects, :id_user_owner, :integer
  end
end
