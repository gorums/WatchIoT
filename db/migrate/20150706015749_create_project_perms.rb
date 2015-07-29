class CreateProjectPerms < ActiveRecord::Migration
  def change
    create_table :project_perms do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end
    add_index :project_perms, :name
  end
end
