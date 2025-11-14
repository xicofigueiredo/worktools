class AddDataValidatedToLearnerInfos < ActiveRecord::Migration[7.0]
  def change
    add_column :learner_infos, :data_validated, :boolean, default: false
  end
end
