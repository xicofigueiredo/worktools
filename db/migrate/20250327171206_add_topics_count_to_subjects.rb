class AddTopicsCountToSubjects < ActiveRecord::Migration[7.0]
  def change
    add_column :subjects, :topics_count, :integer, default: 0, null: false

    Subject.find_each do |subject|
      Subject.reset_counters(subject.id, :topics)
    end
  end
end
