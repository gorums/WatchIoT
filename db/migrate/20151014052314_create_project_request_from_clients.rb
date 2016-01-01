##
# Project request from client model
#
class CreateProjectRequestFromClients < ActiveRecord::Migration
  def change
    create_table :project_request_from_clients do |t|
      t.string :ips # any, CIDR, Ips split by ","

      t.references :project_request
    end

    add_index :project_request_from_clients, :project_request_id
  end
end
