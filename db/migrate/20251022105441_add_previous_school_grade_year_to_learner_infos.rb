class AddPreviousSchoolGradeYearToLearnerInfos < ActiveRecord::Migration[7.0]
  def change
    add_column :learner_infos, :previous_school_grade_year, :string
  end
end
