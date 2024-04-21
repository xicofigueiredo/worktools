class CreateNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :notes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :category
      t.string :topic
      t.date :date
      t.string :follow_up_action
      t.string :status

      t.timestamps
    end
  end
end
