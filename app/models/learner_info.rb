class LearnerInfo < ApplicationRecord
  belongs_to :user, optional: true
  has_many :learner_documents, dependent: :destroy
  has_many :learner_info_logs, dependent: :delete_all

  # validate user needs to be learner?

  def log_update(by_user = nil, saved_changes_hash = nil, note: nil)
    saved_changes_hash ||= saved_changes
    return if saved_changes_hash.blank?

    # ignore non-user-facing changes
    ignore_keys = %w[updated_at]
    changes = saved_changes_hash.except(*ignore_keys)

    return if changes.blank?

    changed_fields = changes.keys.map(&:to_s)
    changed_data = changes.transform_values { |v| { 'from' => v[0], 'to' => v[1] } }

    learner_info_logs.create!(
      user: by_user,
      action: 'update',
      changed_fields: changed_fields,
      changed_data: changed_data,
      note: note
    )
  end
end
