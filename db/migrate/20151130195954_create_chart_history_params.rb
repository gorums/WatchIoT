class CreateChartHistoryParams < ActiveRecord::Migration
  def change
    create_table :chart_history_params do |t|
      t.references :chart_history
      t.references :project
      t.string :param
      t.string :value

      t.timestamps null: false
    end

    add_index :chart_history_params, :chart_history_id
    add_index :chart_history_params, :project_id
  end
end
