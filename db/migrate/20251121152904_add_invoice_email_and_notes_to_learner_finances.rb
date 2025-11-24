class AddInvoiceEmailAndNotesToLearnerFinances < ActiveRecord::Migration[7.0]
  def change
    add_column :learner_finances, :invoice_email, :string
    add_column :learner_finances, :notes, :text
  end
end
