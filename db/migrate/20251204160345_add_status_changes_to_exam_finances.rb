class AddStatusChangesToExamFinances < ActiveRecord::Migration[7.0]
  def change
    add_column :exam_finances, :status_changes, :jsonb, default: []
  end
end
