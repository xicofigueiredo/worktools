class AddSubjectAndTopicToWeeklySlots < ActiveRecord::Migration[7.0]
  def change
    add_reference :weekly_slots, :subject, null: false, foreign_key: true
    add_reference :weekly_slots, :topic, null: false, foreign_key: true
    remove_column :weekly_slots, :subject_name, :string
    remove_column :weekly_slots, :topic_name, :string
  end
end
