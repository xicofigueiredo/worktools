class LearnerDocument < ApplicationRecord
  belongs_to :learner_info
  has_one_attached :file

  # validate document type
end
