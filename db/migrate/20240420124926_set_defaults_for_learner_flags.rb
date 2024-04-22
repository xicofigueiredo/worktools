class SetDefaultsForLearnerFlags < ActiveRecord::Migration[7.0]
  def change
    change_column_default :learner_flags, :asks_for_help, from: nil, to: false
    change_column_default :learner_flags, :takes_notes, from: nil, to: false
    change_column_default :learner_flags, :goes_to_live_lessons, from: nil, to: false
    change_column_default :learner_flags, :does_p2p, from: nil, to: false
    change_column :learner_flags, :action_plan, :text, default: "", null: false
  end
end
