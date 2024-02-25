class CreateGoalsQuestionsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :goals, :questions do |t|
      # t.index [:goal_id, :question_id]
      # t.index [:question_id, :goal_id]
    end
  end
end
