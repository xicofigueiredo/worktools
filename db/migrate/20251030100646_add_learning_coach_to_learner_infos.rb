class AddLearningCoachToLearnerInfos < ActiveRecord::Migration[7.0]
  def change
    add_reference :learner_infos, :learning_coach, foreign_key: { to_table: :users }, index: true
  end
end
