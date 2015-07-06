class AddOwnerColumnToSpace < ActiveRecord::Migration
  def change
    add_column :spaces, :id_user_owner, :integer
  end
end
