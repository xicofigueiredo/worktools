class RevertAddSubjectAndTopicToWeeklySlots < ActiveRecord::Migration[7.0]
  def change
    remove_reference :weekly_slots, :subject, foreign_key: true
    remove_reference :weekly_slots, :topic, foreign_key: true
    add_column :weekly_slots, :subject_name, :string
    add_column :weekly_slots, :topic_name, :string
  end
end
