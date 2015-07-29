class CreateSpaces < ActiveRecord::Migration
  def change
    create_table :spaces do |t|
      t.integer :user_id,
      t.string :name
      t.text :description

      t.timestamps null: false
    end
    add_index :spaces, :user_id
    add_index :spaces, :name
  end
end
