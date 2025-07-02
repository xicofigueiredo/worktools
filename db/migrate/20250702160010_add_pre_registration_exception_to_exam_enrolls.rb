class AddPreRegistrationExceptionToExamEnrolls < ActiveRecord::Migration[7.0]
  class AddPreRegistrationExceptionToExamEnrolls < ActiveRecord::Migration[7.0]
    def change
      # Rename existing exception fields to poor_mock_result_exception
      rename_column :exam_enrolls, :exception_justification, :poor_mock_result_exception_justification
      rename_column :exam_enrolls, :exception_cm_approval, :poor_mock_result_exception_cm_approval
      rename_column :exam_enrolls, :exception_cm_comment, :poor_mock_result_exception_cm_comment
      rename_column :exam_enrolls, :exception_dc_approval, :poor_mock_result_exception_dc_approval
      rename_column :exam_enrolls, :exception_dc_comment, :poor_mock_result_exception_dc_comment
      rename_column :exam_enrolls, :exception_edu_approval, :poor_mock_result_exception_edu_approval
      rename_column :exam_enrolls, :exception_edu_comment, :poor_mock_result_exception_edu_comment

      # Add new pre_registration_exception fields
      add_column :exam_enrolls, :pre_registration_exception_justification, :string
      add_column :exam_enrolls, :pre_registration_exception_cm_approval, :boolean
      add_column :exam_enrolls, :pre_registration_exception_cm_comment, :string
      add_column :exam_enrolls, :pre_registration_exception_dc_approval, :boolean
      add_column :exam_enrolls, :pre_registration_exception_dc_comment, :string
      add_column :exam_enrolls, :pre_registration_exception_edu_approval, :boolean
      add_column :exam_enrolls, :pre_registration_exception_edu_comment, :string
    end
  end
end
