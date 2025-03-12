class Form < ApplicationRecord
  has_many :form_interrogation_joins, dependent: :destroy
  has_many :interrogations, through: :form_interrogation_joins
  has_many :responses, through: :form_interrogation_joins

  # Find forms that are due to be shown
  scope :current, -> { where('scheduled_date <= ?', Date.today) }
  scope :by_subject_name, ->(subject_names) {
    where(subject_names.map { |name| "title ILIKE ?" }.join(' OR '), *subject_names.map { |name| "%#{name}%" })
  }

  def responses_for_user(user)
    Response.joins(:form_interrogation_join)
            .where(user: user)
            .where(form_interrogation_joins: { form_id: id })
  end

  def completed_by?(user)
    interrogations.count == responses_for_user(user).count
  end
end
