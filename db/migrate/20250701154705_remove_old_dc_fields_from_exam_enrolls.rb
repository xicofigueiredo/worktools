class RemoveOldDcFieldsFromExamEnrolls < ActiveRecord::Migration[7.0]
  def change
    # Remove old DC approval fields
    remove_column :exam_enrolls, :dc_approval_justification, :string
    remove_column :exam_enrolls, :dc_approval, :boolean
    remove_column :exam_enrolls, :dc_approval_comment, :string
  end
end
