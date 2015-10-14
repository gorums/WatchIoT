class CreateProjectRequests < ActiveRecord::Migration
  def change
    create_table :project_requests do |t|
      t.integer :request_per_min
      t.string :way       #way can be to_server, from_the_client
      t.string :token     #token is an identification of the request
      t.references :user
      t.references :space
      t.references :project

      t.timestamps null: false
    end

    add_index :project_requests, :user_id
    add_index :project_requests, :space_id
    add_index :project_requests, :project_id
  end
end
