class CreateQuestionsSubjects < ActiveRecord::Migration[7.0]
  def change
    create_table :questions_subjects do |t|
      t.references :question, foreign_key: true
      t.references :subject, foreign_key: true
      t.timestamps
    end
  end
end
