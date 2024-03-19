class RemoveSubjectFromKnowledges < ActiveRecord::Migration[7.0]
  def change
    remove_reference :knowledges, :subject, null: false, foreign_key: true
  end
end
