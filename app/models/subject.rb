class Subject < ApplicationRecord
  has_many :exam_dates
  has_many :topics
  has_many :questions
  has_many :user_topics
  has_many :timelines
  has_many :users, through: :timelines
  validates :category, presence: true

  enum category: [ :lws7, :lws8, :lws9, :igcse, :as, :al, :up, :lang]

  def category_long_form
    self.class.category_options[category.to_sym]
  end

  def self.category_options
    {
      lws7: "Lower Secondary Year 7",
      lws8: "Lower Secondary Year 8",
      lws9: "Lower Secondary Year 9",
      igcse: "IGCSE",
      as: "AS Level",
      al: "A Level",
      up: "UP",
      lang: "Language"
    }
  end
end
