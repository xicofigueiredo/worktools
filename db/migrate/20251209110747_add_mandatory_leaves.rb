class AddMandatoryLeaves < ActiveRecord::Migration[7.0]
  def change
    create_table :mandatory_leaves do |t|
      t.string :name, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.boolean :global, default: false
      t.timestamps
    end

    # Link StaffLeave to MandatoryLeave
    add_reference :staff_leaves, :mandatory_leave, foreign_key: true, optional: true
  end
end
