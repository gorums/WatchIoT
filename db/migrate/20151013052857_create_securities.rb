class CreateSecurities < ActiveRecord::Migration
  def change
    create_table :securities do |t|
      t.string :name
      t.text :description
      t.string :ip
      t.references :user
      t.integer :user_action_id

      t.timestamps null: false
    end

    add_index :securities, :user_id
    add_index :securities, :user_action_id
  end
end
