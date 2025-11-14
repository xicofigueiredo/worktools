class AddPreferredNameAndNativeLanguageToLearnerInfos < ActiveRecord::Migration[7.0]
  def change
    add_column :learner_infos, :preferred_name, :string
    add_column :learner_infos, :native_language, :string
  end
end
