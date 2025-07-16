class ExamFinance < ApplicationRecord
  belongs_to :user
  has_many :specific_papers, dependent: :destroy

  validates :total_cost, presence: true, numericality: { only_integer: true }
end
