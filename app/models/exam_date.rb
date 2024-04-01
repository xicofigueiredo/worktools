class ExamDate < ApplicationRecord
  belongs_to :subject, foreign_key: :subject_id
  has_many :timelines
end
