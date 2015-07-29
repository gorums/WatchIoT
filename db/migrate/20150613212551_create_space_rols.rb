class CreateSpaceRols < ActiveRecord::Migration
  def change
    create_table :space_rols do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end
    add_index :space_rols, :name
  end
end
