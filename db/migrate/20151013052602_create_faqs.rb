class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :faqs do |t|
      t.string :question
      t.string :answer
      t.integer :order
    end
  end
end
