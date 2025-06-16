class ModifyMoodleTopics < ActiveRecord::Migration[7.0]
  def change
    # Make timeline_id optional by removing null constraint
    change_column_null :moodle_topics, :timeline_id, true

    # Add moodle_timeline_id as a foreign key
    add_reference :moodle_topics, :moodle_timeline, null: true, foreign_key: true
  end
end
