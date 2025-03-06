class CreateResponses < ActiveRecord::Migration[7.0]
  def change
    create_table :responses do |t|
      t.references :form_interrogation_join, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end

    add_index :responses, [:user_id, :form_interrogation_join_id], unique: true, name: 'index_user_interrogation_unique'
  end
end
