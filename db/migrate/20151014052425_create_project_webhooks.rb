##
# Project webhook model
#
class CreateProjectWebhooks < ActiveRecord::Migration
  def change
    create_table :project_webhooks do |t|
      t.string :url # Webservice
      t.string :token # A token to identify our request
      t.references :user
      t.references :space
      t.references :project

      t.timestamps null: false
    end

    add_index :project_webhooks, :user_id
    add_index :project_webhooks, :space_id
    add_index :project_webhooks, :project_id
  end
end
