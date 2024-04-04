class Subject < ApplicationRecord
  has_many :exam_dates
  has_many :topics
  has_many :questions
  has_many :user_topics
  has_many :timelines
  validates :category, presence: true

  enum category: [:lws, :igcse, :as, :al, :up, :tbe]

  def category_long_form
    self.class.category_options[category.to_sym]
  end

  def self.category_options
    {
      lws: "Lower Secondary",
      igcse: "IGCSE",
      as: "AS Level",
      al: "A Level",
      up: "UP",
      tbe: "To be enrolled"
    }
  end
end
