class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.text :url
      t.text :title
      t.text :content
      t.text :author
      t.text :category
      t.text :image

      t.timestamps null: false
    end
  end
end
