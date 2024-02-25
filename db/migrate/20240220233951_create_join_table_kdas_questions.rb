class CreateJoinTableKdasQuestions < ActiveRecord::Migration[7.0]
  def change
    create_join_table :kdas, :questions do |t|
      # t.index [:kda_id, :question_id]
      # t.index [:question_id, :kda_id]
    end
  end
end
