class CreateMoodleAssignments < ActiveRecord::Migration[7.0]
  def change
    create_table :moodle_assignments do |t|
      t.bigint  :moodle_id,       null: false
      t.bigint  :subject_id,      null: false
      t.bigint  :moodle_course_id, null: false
      t.bigint  :cmid,            null: false
      t.string  :name,            null: false

      t.timestamps
    end

    add_index :moodle_assignments, :moodle_id, unique: true
    add_index :moodle_assignments, :subject_id
    add_index :moodle_assignments, :moodle_course_id
    add_index :moodle_assignments, :cmid

    add_foreign_key :moodle_assignments, :subjects
  end
end
