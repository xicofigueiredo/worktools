class CreateWeeks < ActiveRecord::Migration[7.0]
  def change
    create_table :weeks do |t|
      t.date :start_date, presence: true
      t.date :end_date, presence: true
      t.string :name, presence: true

      t.timestamps
    end
  end
end
