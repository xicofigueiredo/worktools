class ExamEnrollDocument < ApplicationRecord
  belongs_to :exam_enroll

  validates :file_name, presence: true
  validates :file_type, presence: true
  validates :file_path, presence: true
end
