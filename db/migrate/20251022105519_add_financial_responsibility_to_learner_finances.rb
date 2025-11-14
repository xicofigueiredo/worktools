class AddFinancialResponsibilityToLearnerFinances < ActiveRecord::Migration[7.0]
  def change
    add_column :learner_finances, :financial_responsibility, :text
  end
end
