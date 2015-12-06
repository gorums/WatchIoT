class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.text :description
      t.string :action, limit: 20
      t.references :user
      t.integer :user_action_id

      t.timestamps null: false
    end

    add_index :logs, :user_id
    add_index :logs, :user_action_id
  end
end
