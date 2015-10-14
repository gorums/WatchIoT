class CreateTeamSpaces < ActiveRecord::Migration
  def change
    create_table :team_spaces do |t|
      t.references :user
      t.references :permission
      t.references :space
      t.integer :user_team_id

      t.timestamps null: false
    end

    add_index :team_spaces, :user_id
    add_index :team_spaces, :permission_id
    add_index :team_spaces, :space_id
    add_index :team_spaces, :user_team_id
  end
end
