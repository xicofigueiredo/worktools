class CreateNewsletters < ActiveRecord::Migration[7.0]
  def change
    create_table :newsletters do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.datetime :published_at, null: false
      t.string :filter_country
      t.string :filter_role
      t.string :filter_level
      t.string :filter_region

      t.timestamps
    end

    add_index :newsletters, :published_at
    add_index :newsletters, :filter_country
    add_index :newsletters, :filter_role
    add_index :newsletters, :filter_level
    add_index :newsletters, :filter_region
  end
end
