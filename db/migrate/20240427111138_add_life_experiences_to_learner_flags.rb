class AddLifeExperiencesToLearnerFlags < ActiveRecord::Migration[7.0]
  def change
    add_column :learner_flags, :life_experiences, :boolean, default: false
  end
end
