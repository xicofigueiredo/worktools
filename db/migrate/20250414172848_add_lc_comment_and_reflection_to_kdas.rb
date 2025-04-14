class AddLcCommentAndReflectionToKdas < ActiveRecord::Migration[7.0]
  def change
    add_column :kdas, :lc_comment, :text
    add_column :kdas, :reflection, :text
  end
end
