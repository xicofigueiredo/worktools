class UpdateApprovedByColumnsOnConsents < ActiveRecord::Migration[7.0]
  def change
    rename_column :consents, :consent_approved_by, :consent_approved_by_learner
    add_column :consents, :consent_approved_by_guardian, :string
  end
end
