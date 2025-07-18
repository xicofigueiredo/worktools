class AddNumberOfSubjectsToExamFinances < ActiveRecord::Migration[7.0]
  def change
    add_column :exam_finances, :number_of_subjects, :integer, null: false, default: 0
  end
end
