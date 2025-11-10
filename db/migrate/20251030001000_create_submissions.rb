class CreateSubmissions < ActiveRecord::Migration[7.0]
  def change
    create_table :submissions do |t|
      t.bigint   :user_id, null: false
      t.decimal  :grade, precision: 4, scale: 2
      t.datetime :submission_date
      t.datetime :grading_date

      t.timestamps
    end

    add_index :submissions, :user_id
  end
end
