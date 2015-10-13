class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :name, limit: 20

    end
  end
end
