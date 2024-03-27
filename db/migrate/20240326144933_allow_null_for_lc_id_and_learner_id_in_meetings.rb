class AllowNullForLcIdAndLearnerIdInMeetings < ActiveRecord::Migration[7.0]
  def change
    change_column_null :meetings, :lc_id, true
    change_column_null :meetings, :learner_id, true
  end
end
