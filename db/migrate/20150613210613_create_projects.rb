class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :user_id,
      t.string :name
      t.text :description

      t.timestamps null: false
    end
    add_index :projects, :user_id
    add_index :projects, :name
  end
end
