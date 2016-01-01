##
# Project parameters model
#
class CreateProjectParameters < ActiveRecord::Migration
  def change
    create_table :project_parameters do |t|
      t.string :name
      t.string :type_param # type can be string, integer, decimal, boolean
      t.references :user
      t.references :space
      t.references :project

      t.timestamps null: false
    end

    add_index :project_parameters, :user_id
    add_index :project_parameters, :space_id
    add_index :project_parameters, :project_id
  end
end
