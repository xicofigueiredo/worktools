class CreateLearnerDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :learner_documents do |t|
      t.references :learner_info, null: false, foreign_key: true, index: true
      t.string :file_name
      t.string :document_type, null: false
      t.text :description

      t.timestamps
    end

    add_index :learner_documents, [:learner_info_id, :document_type], name: 'index_learner_docs_on_learner_info_and_type'
    add_index :learner_documents, :document_type
  end
end
