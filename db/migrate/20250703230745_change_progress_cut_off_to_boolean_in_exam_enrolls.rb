class ChangeProgressCutOffToBooleanInExamEnrolls < ActiveRecord::Migration[7.0]
  def up
    change_column :exam_enrolls, :progress_cut_off, :boolean, using: 'CASE WHEN progress_cut_off = \'1\' OR progress_cut_off = \'true\' THEN true ELSE false END', default: false
  end

  def down
    change_column :exam_enrolls, :progress_cut_off, :string
  end
end
