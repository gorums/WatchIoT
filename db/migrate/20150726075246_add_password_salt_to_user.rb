class AddPasswordSaltToUser < ActiveRecord::Migration
  def change
    add_column :users, :passwd_salt, :string, :after => "passwd"
  end
end
