class ExamFinance < ApplicationRecord
  belongs_to :user
  has_many :specific_papers, dependent: :destroy

  validates :total_cost, presence: true, numericality: true
  validates :number_of_subjects, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def update_number_of_subjects(count)
    update_column(:number_of_subjects, count)
  end
end
