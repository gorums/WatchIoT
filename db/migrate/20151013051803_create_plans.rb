##
# Plan model
#
class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.decimal :amount_per_month
    end

    add_index :plans, :name
  end
end
