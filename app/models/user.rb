class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :holidays
  has_many :timelines
  has_many :weekly_goals
  has_many :sprint_goals
  has_one :users_hub
  has_one :hub, through: :users_hub
  has_many :user_topics
  has_many :topics, through: :user_topics
  attr_accessor :weekly_goal_completed
  has_many :kdas


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def subjects_without_timeline
    Subject.left_outer_joins(:timelines).where(timelines: { user_id: nil })
  end

  def timelines_sorted_by_balance
    timelines.sort_by { |timeline| timeline.balance || 0 }
  end

end
