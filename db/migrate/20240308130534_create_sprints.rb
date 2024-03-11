class CreateSprints < ActiveRecord::Migration[7.0]
  def change
    create_table :sprints do |t|
      t.string :name, presence: true
      t.date :start_date, presence: true
      t.date :end_date, presence: true

      t.timestamps
    end
  end
end
