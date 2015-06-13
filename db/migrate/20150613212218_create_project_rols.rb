class CreateProjectRols < ActiveRecord::Migration
  def change
    create_table :project_rols do |t|
      t.string :name
      t.string :description

      t.timestamps null: false
    end
  end
end
