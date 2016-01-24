class AddLangToFaqs < ActiveRecord::Migration
  def change
    add_column :faqs, :lang, :string, default: 'en'
  end
end
