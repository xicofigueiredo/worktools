class AddMoodleIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :moodle_id, :bigint
  end
end
