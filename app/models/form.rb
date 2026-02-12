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
    user_responses = responses_for_user(user)
    total_questions = interrogations.count

    # Special case: Sports form - if first answer is "No", only 1 response is needed
    if title&.include?("Sports Information Form")
      first_question = form_interrogation_joins.order(:id).first
      first_response = user_responses.find { |r| r.form_interrogation_join_id == first_question.id }

      # If first answer is "No", form is completed with just that answer
      if first_response&.content == "No"
        return true
      end
    end

    # Otherwise, all questions must be answered
    total_questions == user_responses.count
  end
end
