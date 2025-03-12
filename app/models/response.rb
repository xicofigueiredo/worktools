class Response < ApplicationRecord
  belongs_to :form_interrogation_join
  belongs_to :user
  before_create :set_completed_at

  validates :user_id, uniqueness: { scope: :form_interrogation_join_id }
  validates :content, presence: true

  def editable?
    completed_at && completed_at >= 1.day.ago
  end

  # Helper methods to access related objects
  def interrogation
    form_interrogation_join.interrogation
  end

  def form
    form_interrogation_join.form
  end

  private

  def set_completed_at
    self.completed_at ||= Time.current
  end
end
