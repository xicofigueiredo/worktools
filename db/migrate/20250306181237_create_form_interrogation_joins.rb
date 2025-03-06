class CreateFormInterrogationJoins < ActiveRecord::Migration[7.0]
  def change
    create_table :form_interrogation_joins do |t|
      t.references :form, null: false, foreign_key: true
      t.references :interrogation, null: false, foreign_key: true

      t.timestamps
    end
    add_index :form_interrogation_joins, [:form_id, :interrogation_id], unique: true, name: 'index_form_interrogation_unique'
  end
end
