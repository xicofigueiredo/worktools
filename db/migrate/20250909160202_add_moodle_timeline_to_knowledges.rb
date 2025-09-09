class AddMoodleTimelineToKnowledges < ActiveRecord::Migration[7.0]
  def change
    add_reference :knowledges, :moodle_timeline, null: true, foreign_key: true
    add_index :knowledges, :moodle_timeline_id
  end
end
