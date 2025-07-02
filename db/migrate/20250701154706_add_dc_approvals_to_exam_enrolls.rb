class AddDcApprovalsToExamEnrolls < ActiveRecord::Migration[7.0]
  def change
    # Add DC approval fields for extension
    add_column :exam_enrolls, :extension_dc_approval, :boolean
    add_column :exam_enrolls, :extension_dc_comment, :string

    # Add DC approval fields for exception
    add_column :exam_enrolls, :exception_dc_approval, :boolean
    add_column :exam_enrolls, :exception_dc_comment, :string
  end
end
