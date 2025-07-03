class ChangeCodeToStringInExamEnrolls < ActiveRecord::Migration[7.0]
  def up
    change_column :exam_enrolls, :code, :string
  end

  def down
    change_column :exam_enrolls, :code, :integer
  end
end
