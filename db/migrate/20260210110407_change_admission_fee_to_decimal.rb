class ChangeAdmissionFeeToDecimal < ActiveRecord::Migration[7.0]
  def change
    change_column :learner_finances, :admission_fee, :decimal, precision: 10, scale: 2
    change_column :learner_finances, :billable_af, :decimal, precision: 10, scale: 2
  end
end
