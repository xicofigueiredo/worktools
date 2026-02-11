class AddFinanceStatusToExamEnrolls < ActiveRecord::Migration[7.0]
  def change
    add_column :exam_enrolls, :finance_status, :string, null: false, default: 'No Status'
  end
end
