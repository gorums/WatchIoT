class AddVerifyToEmails < ActiveRecord::Migration
  def change
    add_column :emails, 'checked', :boolean
  end
end
