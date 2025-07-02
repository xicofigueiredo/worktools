class AddStatusToExamEnrolls < ActiveRecord::Migration[7.0]
  def change
    add_column :exam_enrolls, :status, :string
  end
end
