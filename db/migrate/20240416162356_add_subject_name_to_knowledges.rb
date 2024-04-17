class AddSubjectNameToKnowledges < ActiveRecord::Migration[7.0]
  def change
    add_column :knowledges, :subject_name, :string
    remove_foreign_key :knowledges, :timelines
    add_foreign_key :knowledges, :timelines, on_delete: :cascade
  end
end
