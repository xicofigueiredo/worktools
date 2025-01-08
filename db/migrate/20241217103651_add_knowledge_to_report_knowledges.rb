class AddKnowledgeToReportKnowledges < ActiveRecord::Migration[7.0]
  def change
    add_reference :report_knowledges, :knowledge, foreign_key: true
  end
end
