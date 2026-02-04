class ChangeLearnerFinanceFieldsToDecimal < ActiveRecord::Migration[7.0]
  def change
    change_column :learner_finances, :monthly_fee, :decimal, precision: 10, scale: 2
    change_column :learner_finances, :scholarship, :decimal, precision: 10, scale: 2
    change_column :learner_finances, :billable_mf, :decimal, precision: 10, scale: 2
    change_column :learner_finances, :renewal_fee, :decimal, precision: 10, scale: 2
    change_column :learner_finances, :billable_rf, :decimal, precision: 10, scale: 2
  end
end
