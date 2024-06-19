class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.references :user, null: false, foreign_key: true
      t.references :sprint, null: false, foreign_key: true
      t.text :general
      t.text :lc_comment
      t.text :reflection

      t.timestamps
    end
  end
end
