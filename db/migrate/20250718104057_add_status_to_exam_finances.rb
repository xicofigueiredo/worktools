class AddStatusToExamFinances < ActiveRecord::Migration[7.0]
  def change
    add_column :exam_finances, :status, :string, null: false, default: 'No Status'
  end
end
