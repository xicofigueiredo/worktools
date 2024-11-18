class AddPersonalizedToReportKnowledges < ActiveRecord::Migration[6.1]
  def change
    add_column :report_knowledges, :personalized, :boolean, default: false, null: false
  end
end
