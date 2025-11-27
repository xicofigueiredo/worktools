class AddHasDebtToLearnerFinances < ActiveRecord::Migration[7.0]
  def change
    add_column :learner_finances, :has_debt, :boolean, default: false, null: false
  end
end
