class RestructureExceptionFieldsInExamEnrolls < ActiveRecord::Migration[7.0]
  def change
    # Remove old exception columns
    remove_column :exam_enrolls, :exception_justification
    remove_column :exam_enrolls, :exception_cm_approval
    remove_column :exam_enrolls, :exception_cm_comment
    remove_column :exam_enrolls, :exception_edu_approval
    remove_column :exam_enrolls, :exception_edu_comment
    remove_column :exam_enrolls, :exception_dc_approval
    remove_column :exam_enrolls, :exception_dc_comment

    # Add pre-registration exception columns
    add_column :exam_enrolls, :pre_registration_exception_justification, :string
    add_column :exam_enrolls, :pre_registration_exception_cm_approval, :boolean
    add_column :exam_enrolls, :pre_registration_exception_cm_comment, :string
    add_column :exam_enrolls, :pre_registration_exception_dc_approval, :boolean
    add_column :exam_enrolls, :pre_registration_exception_dc_comment, :string
    add_column :exam_enrolls, :pre_registration_exception_edu_approval, :boolean
    add_column :exam_enrolls, :pre_registration_exception_edu_comment, :string

    # Add failed mock exception columns
    add_column :exam_enrolls, :failed_mock_exception_justification, :string
    add_column :exam_enrolls, :failed_mock_exception_cm_approval, :boolean
    add_column :exam_enrolls, :failed_mock_exception_cm_comment, :string
    add_column :exam_enrolls, :failed_mock_exception_dc_approval, :boolean
    add_column :exam_enrolls, :failed_mock_exception_dc_comment, :string
    add_column :exam_enrolls, :failed_mock_exception_edu_approval, :boolean
    add_column :exam_enrolls, :failed_mock_exception_edu_comment, :string
  end
end
