class AddNotesToLearnerInfos < ActiveRecord::Migration[7.0]
  def change
    add_column :learner_infos, :notes, :text
  end
end
