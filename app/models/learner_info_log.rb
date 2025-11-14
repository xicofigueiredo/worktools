class LearnerInfoLog < ApplicationRecord
  belongs_to :learner_info
  belongs_to :user, optional: true

  validates :action, presence: true

  def summary
    case action
    when 'update'
      if changed_fields.present?
        "Updated: #{changed_fields.join(', ')}"
      else
        "Updated"
      end
    when 'document_upload'
      if changed_data.is_a?(Array) && changed_data.present?
        filenames = changed_data.map { |d| d['filename'] }.compact.join(', ')
        doc_type = changed_data.first['document_type']
        "Uploaded #{changed_data.size} document(s) for #{doc_type}: #{filenames}"
      elsif changed_data.is_a?(Hash)
        "Document uploaded: #{changed_data['filename'] || changed_data['document_type']}"
      else
        "Document uploaded"
      end
    when 'document_delete'
      "Document removed: #{changed_data['filename'] || changed_data['document_type']}"
    else
      action.to_s.humanize
    end
  end
end
