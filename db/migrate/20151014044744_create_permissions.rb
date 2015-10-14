class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :category
      t.string :permission
    end
  end
end
