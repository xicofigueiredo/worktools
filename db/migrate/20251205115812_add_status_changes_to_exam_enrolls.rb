class AddStatusChangesToExamEnrolls < ActiveRecord::Migration[7.0]
  def change
    add_column :exam_enrolls, :status_changes, :jsonb
  end
end
