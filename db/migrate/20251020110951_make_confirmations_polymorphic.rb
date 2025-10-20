class MakeConfirmationsPolymorphic < ActiveRecord::Migration[7.0]
  def change
    add_column :confirmations, :confirmable_id, :bigint
    add_column :confirmations, :confirmable_type, :string

    reversible do |dir|
      dir.up do
        execute <<-SQL.squish
          UPDATE confirmations
          SET confirmable_id = staff_leave_id,
              confirmable_type = 'StaffLeave'
          WHERE staff_leave_id IS NOT NULL;
        SQL
      end
    end

    add_index :confirmations, [:confirmable_type, :confirmable_id]
    add_index :confirmations, [:confirmable_type, :confirmable_id, :approver_id], name: "index_confirmations_on_confirmable_and_approver_id"

    change_column_null :confirmations, :confirmable_id, false
    change_column_null :confirmations, :confirmable_type, false

    change_column_null :confirmations, :staff_leave_id, true

    remove_index :confirmations, name: "index_confirmations_on_staff_leave_id" if index_exists?(:confirmations, :staff_leave_id)
    remove_index :confirmations, name: "index_confirmations_on_staff_leave_id_and_approver_id" if index_exists?(:confirmations, [:staff_leave_id, :approver_id])
  end
end
