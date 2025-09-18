class AddExceptionErrorsToStaffLeaves < ActiveRecord::Migration[7.0]
  def change
    add_column :staff_leaves, :exception_errors, :text
  end
end
