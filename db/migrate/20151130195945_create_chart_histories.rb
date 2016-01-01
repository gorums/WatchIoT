##
# Chart history model
#
class CreateChartHistories < ActiveRecord::Migration
  def change
    create_table :chart_histories do |t|
      t.references :project
      t.references :space
      t.references :user
      t.string :stage # The stage processor for each request

      t.timestamps null: false
    end

    add_index :chart_histories, :user_id
    add_index :chart_histories, :space_id
    add_index :chart_histories, :project_id
  end
end
