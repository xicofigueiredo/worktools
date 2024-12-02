class ChangeGradeTypeInReportKnowledges < ActiveRecord::Migration[7.0]
  def up
    change_column :report_knowledges, :grade, :string
  end

  def down
    change_column :report_knowledges, :grade, :integer
  end
end
