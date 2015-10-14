class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.references :user
      t.integer :user_team_id   #identify a member of this team
      t.references :permission

      t.timestamps null: false
    end

    add_index :teams, :user_id
    add_index :teams, :user_team_id
    add_index :teams, :permission_id
  end
end
