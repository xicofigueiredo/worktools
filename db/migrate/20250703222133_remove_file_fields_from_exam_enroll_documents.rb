class RemoveFileFieldsFromExamEnrollDocuments < ActiveRecord::Migration[7.0]
  def change
    remove_column :exam_enroll_documents, :file_path, :string
    remove_column :exam_enroll_documents, :file_type, :string
  end
end
