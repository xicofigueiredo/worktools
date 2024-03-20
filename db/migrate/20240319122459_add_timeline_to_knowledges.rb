class AddTimelineToKnowledges < ActiveRecord::Migration[7.0]
  def change
    add_reference :knowledges, :timeline, null: true, foreign_key: true
  end
end
