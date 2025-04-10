class RemoveContentFromNewsletters < ActiveRecord::Migration[7.0]
  def change
    remove_column :newsletters, :content, :text
  end
end
