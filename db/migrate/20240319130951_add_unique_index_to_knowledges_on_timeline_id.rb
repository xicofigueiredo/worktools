class AddUniqueIndexToKnowledgesOnTimelineId < ActiveRecord::Migration[7.0]
  def change
    add_index :knowledges, :timeline_id, unique: true
  end
end
