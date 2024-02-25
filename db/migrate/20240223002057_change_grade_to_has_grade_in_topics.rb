class ChangeGradeToHasGradeInTopics < ActiveRecord::Migration[7.0]
  def change
    rename_column :topics, :grade, :has_grade
  end
end
