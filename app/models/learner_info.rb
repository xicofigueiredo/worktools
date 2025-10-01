class LearnerInfo < ApplicationRecord
  belongs_to :user, optional: true
  has_many :learner_documents, dependent: :destroy

  # validate user needs to be learner?
end
