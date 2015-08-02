class AddNewColumnProject < ActiveRecord::Migration
  def change
    add_column :projects, :space_id, :integer
    add_index :projects, :space_id
  end
end
