class AddSubjectToMoodleTimeline < ActiveRecord::Migration[7.0]
  def change
    add_reference :moodle_timelines, :subject, null: true, foreign_key: true
  end
end
