class CreateDescrip < ActiveRecord::Migration
  def change
    create_table :descrips do |t|
      t.string :description
      t.string :icon
      t.string :lang, default: 'en'
      t.string :title
    end
  end
end
