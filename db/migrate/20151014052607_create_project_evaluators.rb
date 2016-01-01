##
# Project evaluator model
#
class CreateProjectEvaluators < ActiveRecord::Migration
  def change
    create_table :project_evaluators do |t|
      t.text :script
      t.references :user
      t.references :space
      t.references :project

      t.timestamps null: false
    end

    add_index :project_evaluators, :user_id
    add_index :project_evaluators, :space_id
    add_index :project_evaluators, :project_id
  end
end
