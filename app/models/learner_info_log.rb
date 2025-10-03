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
      "Document uploaded: #{changed_data['filename'] || changed_data['document_type']}"
    when 'document_delete'
      "Document removed: #{changed_data['filename'] || changed_data['document_type']}"
    else
      action.to_s.humanize
    end
  end
end
