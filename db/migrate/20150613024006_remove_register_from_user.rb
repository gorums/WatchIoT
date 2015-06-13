class RemoveRegisterFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :regiter, :timestamp
  end
end
