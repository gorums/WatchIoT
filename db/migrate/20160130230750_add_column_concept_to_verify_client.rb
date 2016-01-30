class AddColumnConceptToVerifyClient < ActiveRecord::Migration
  def change
    add_column :verify_clients, 'concept', :string
  end
end
