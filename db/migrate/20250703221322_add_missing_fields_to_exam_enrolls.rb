class AddMissingFieldsToExamEnrolls < ActiveRecord::Migration[7.0]
  def change
    add_column :exam_enrolls, :specific_papers, :string
  end
end
