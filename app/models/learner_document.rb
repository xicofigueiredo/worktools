class LearnerDocument < ApplicationRecord
  DOCUMENT_TYPES = %w[
    contract
    special_needs
    last_term_report
    proof_of_payment
    learner_id
    parent_id
    medical_form
    letter_of_interest
    picture
  ].freeze

  belongs_to :learner_info
  has_one_attached :file

  validates :document_type, presence: true, inclusion: { in: DOCUMENT_TYPES }
  validate :file_attached

  def human_type
    document_type.tr('_', ' ').titleize.gsub(/\bId\b/, 'ID')
  end

  private

  def file_attached
    errors.add(:file, "must be attached") unless file.attached?
  end
end
