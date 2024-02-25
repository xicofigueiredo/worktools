class Topic < ApplicationRecord
  belongs_to :subject
  has_many :user_topics
  has_many :users, through: :user_topics
end
