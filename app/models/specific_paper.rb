class SpecificPaper < ApplicationRecord
  belongs_to :exam_finance
  belongs_to :exam_enroll

  validates :name, presence: true
  validates :cost, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
