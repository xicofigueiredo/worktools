class AddMoodleIdToSubjects < ActiveRecord::Migration[7.0]
  def change
    add_column :subjects, :moodle_id, :integer
  end
end
