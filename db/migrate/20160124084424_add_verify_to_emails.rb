class AddVerifyToEmails < ActiveRecord::Migration
  def change
    add_column :emails, 'checked', :boolean, default: false
  end
end
