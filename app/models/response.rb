class Response < ApplicationRecord
  belongs_to :form_interrogation_join
  belongs_to :user

  validates :user_id, uniqueness: { scope: :form_interrogation_join_id }
  validates :content, presence: true

  # Helper methods to access related objects
  def interrogation
    form_interrogation_join.interrogation
  end

  def form
    form_interrogation_join.form
  end
end
