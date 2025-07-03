class ExamEnrollDocument < ApplicationRecord
  belongs_to :exam_enroll
  has_one_attached :file

  validates :file_name, presence: true
  validate :acceptable_file_type, if: -> { file.attached? }

  private

  def acceptable_file_type
    return unless file.attached?

    acceptable_types = [
      'application/pdf',                    # PDF
      'application/msword',                 # Word (.doc)
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document' # Word (.docx)
    ]

    unless acceptable_types.include?(file.content_type)
      errors.add(:file, 'must be a PDF or Word document')
    end
  end
end
