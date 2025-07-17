class AddPaperFieldsToExamEnrolls < ActiveRecord::Migration[7.0]
  def change
    add_column :exam_enrolls, :paper1, :string
    add_column :exam_enrolls, :paper2, :string
    add_column :exam_enrolls, :paper3, :string
    add_column :exam_enrolls, :paper4, :string
    add_column :exam_enrolls, :paper5, :string
    add_column :exam_enrolls, :paper1_cost, :float
    add_column :exam_enrolls, :paper2_cost, :float
    add_column :exam_enrolls, :paper3_cost, :float
    add_column :exam_enrolls, :paper4_cost, :float
    add_column :exam_enrolls, :paper5_cost, :float
  end
end
