class AddUniqueIndexToMoodleTimelines < ActiveRecord::Migration[7.0]
  def change
    # Add unique index on user_id and subject_id to prevent duplicate timelines
    add_index :moodle_timelines, [:user_id, :subject_id], unique: true, name: 'index_moodle_timelines_on_user_and_subject'
  end
end
