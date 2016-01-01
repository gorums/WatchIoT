##
# Feature model
#
class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :name

    end
  end
end
