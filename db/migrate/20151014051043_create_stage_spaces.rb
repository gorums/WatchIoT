class CreateStageSpaces < ActiveRecord::Migration
  def change
    create_table :stage_spaces do |t|
      t.string :stage, limit: 15
      t.boolean :notif_by_email, default: true
      t.boolean :notif_by_sms, default: false
      t.boolean :notif_by_webhook, default: false
      t.references :user
      t.references :space

      t.timestamps null: false
    end

    add_index :stage_spaces, :user_id
    add_index :stage_spaces, :space_id
  end
end
