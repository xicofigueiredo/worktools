class AddMoodleTimelineToExamEnrolls < ActiveRecord::Migration[7.0]
  def change
    add_reference :exam_enrolls, :moodle_timeline, foreign_key: true
  end
end
