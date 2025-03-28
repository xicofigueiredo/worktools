class Topic < ApplicationRecord
  belongs_to :subject, counter_cache: true
  has_many :user_topics
  has_many :users, through: :user_topics

  def deadline_changed_for_current_user?(user)
    user_topic = user_topics.find_by(user:)
    user_topic&.saved_change_to_deadline?
  end
end
