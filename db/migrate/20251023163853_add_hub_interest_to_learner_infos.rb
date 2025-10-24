class AddHubInterestToLearnerInfos < ActiveRecord::Migration[7.0]
  def change
    add_reference :learner_infos, :hub, foreign_key: true, index: true, null: true
  end
end
