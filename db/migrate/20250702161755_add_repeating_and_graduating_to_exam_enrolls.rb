class AddRepeatingAndGraduatingToExamEnrolls < ActiveRecord::Migration[7.0]
  def change
    add_column :exam_enrolls, :repeating, :boolean, default: false
    add_column :exam_enrolls, :graduating, :boolean, default: false
  end
end
