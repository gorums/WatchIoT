class CreateProjectRols < ActiveRecord::Migration
  def change
    create_table :project_rols do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end
    add_index :project_rols, :name
  end
end
