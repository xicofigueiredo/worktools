class CreateLearnerFlags < ActiveRecord::Migration[7.0]
  def change
    create_table :learner_flags do |t|
      t.boolean :asks_for_help
      t.boolean :takes_notes
      t.boolean :goes_to_live_lessons
      t.boolean :does_p2p
      t.text :action_plan
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
