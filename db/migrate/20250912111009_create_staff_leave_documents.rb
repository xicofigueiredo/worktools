class CreateStaffLeaveDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :staff_leave_documents do |t|
      t.references :staff_leave, null: false, foreign_key: true
      t.string :file_name
      t.text :description

      t.timestamps
    end
  end
end
