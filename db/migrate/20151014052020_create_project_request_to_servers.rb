##
# Project request to server model
#
class CreateProjectRequestToServers < ActiveRecord::Migration
  def change
    create_table :project_request_to_servers do |t|
      t.string :url
      t.string :method # GET or POST
      t.string :content_type
      t.string :raw
      t.references :project_request
    end

    add_index :project_request_to_servers, :project_request_id
  end
end
