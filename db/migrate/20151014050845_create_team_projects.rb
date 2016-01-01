##
# Team project model
#
class CreateTeamProjects < ActiveRecord::Migration
  def change
    create_table :team_projects do |t|
      t.references :user
      t.references :permission
      t.references :space
      t.references :project
      t.integer :user_team_id

      t.timestamps null: false
    end

    add_index :team_projects, :user_id
    add_index :team_projects, :permission_id
    add_index :team_projects, :space_id
    add_index :team_projects, :project_id
    add_index :team_projects, :user_team_id
  end
end
