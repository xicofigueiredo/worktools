class AddLcCommentAndReflectionToWeeklyGoals < ActiveRecord::Migration[7.0]
  def change
    add_column :weekly_goals, :lc_comment, :text
    add_column :weekly_goals, :reflection, :text
  end
end
