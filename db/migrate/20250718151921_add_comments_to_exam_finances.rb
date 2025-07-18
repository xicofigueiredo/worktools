class AddCommentsToExamFinances < ActiveRecord::Migration[7.0]
  def change
    add_column :exam_finances, :comments, :text
  end
end
