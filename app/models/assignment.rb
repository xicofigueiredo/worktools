class Assignment < ApplicationRecord
  belongs_to :user
  belongs_to :subject

  validates :user_id, presence: true
  validates :subject_id, presence: true
  validates :moodle_id, presence: true, uniqueness: { scope: :user_id }
  validates :name, presence: true

  scope :by_subject, ->(subject_id) { where(subject_id: subject_id) }
end
