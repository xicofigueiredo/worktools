class ChangeEmergencyProtocolChoiceToTextInLearnerInfos < ActiveRecord::Migration[7.0]
  def change
    change_column :learner_infos, :emergency_protocol_choice, :string
  end
end
