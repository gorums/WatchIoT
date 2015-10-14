class CreateProjectRequestsFromClient < ActiveRecord::Migration
  def change
    create_table :project_requests_from_clients do |t|
      t.string :ips   #any, CIDR, Ips split by ","

      t.references :project_request
    end

    add_index :project_requests_from_clients, :project_request_id
  end
end
