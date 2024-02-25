class ChangeGradeToBooleanInTopics < ActiveRecord::Migration[7.0]
  def change
    change_column :topics, :grade, 'boolean USING CAST(grade AS boolean)'
  end
end
