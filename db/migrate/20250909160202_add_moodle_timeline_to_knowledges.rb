class AddMoodleTimelineToKnowledges < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:knowledges, :moodle_timeline_id)
      add_reference :knowledges, :moodle_timeline, null: true, foreign_key: true, index: true
    end
  end
end
