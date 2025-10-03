class CreateLearnerInfoLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :learner_info_logs do |t|
      t.bigint :learner_info_id, null: false
      t.bigint :user_id
      t.string :action, null: false
      t.string :changed_fields, array: true, default: []
      t.jsonb :changed_data, default: {}
      t.text :note
      t.timestamps
    end

    add_index :learner_info_logs, :learner_info_id
    add_index :learner_info_logs, :user_id
    add_index :learner_info_logs, :created_at
  end
end
