##
# Chart history model
#
class CreateCharts < ActiveRecord::Migration
  def change
    create_table :charts do |t|
      t.references :project
      t.references :space
      t.references :user

      t.timestamps null: false
    end

    add_index :charts, :user_id
    add_index :charts, :space_id
    add_index :charts, :project_id
  end
end
