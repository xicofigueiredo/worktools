class CreateAssignments < ActiveRecord::Migration[7.0]
  def change
    create_table :assignments do |t|
      # Associations
      t.references :user, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true

      # Moodle identifiers
      t.bigint :moodle_id, null: false            # Assignment ID in Moodle
      t.bigint :moodle_course_id, null: false     # Course ID in Moodle
      t.bigint :cmid                              # Course module ID in Moodle

      # Core fields (mirroring Moodle)
      t.string  :name, null: false
      t.text    :intro
      t.datetime :allow_submissions_from
      t.datetime :due_date
      t.datetime :cutoff_date
      t.decimal :max_grade, precision: 10, scale: 2
      t.integer :max_attempts
      t.datetime :submission_date
      t.datetime :evaluation_date
      t.decimal :grade, precision: 10, scale: 2
      t.integer :number_attempts
      t.integer :number_submissions
      t.integer :number_submissions_late
      t.integer :number_submissions_late_late
      t.integer :number_submissions_late_late_late

      t.timestamps
    end

    add_index :assignments, :moodle_id, unique: true
    add_index :assignments, [:subject_id, :moodle_id]
    add_index :assignments, :moodle_course_id
  end
end
