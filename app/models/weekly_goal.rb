class WeeklyGoal < ApplicationRecord
  belongs_to :user
  belongs_to :week

  validates :user_id, presence: true
  validates :week_id, presence: true
  has_many :weekly_slots, dependent: :destroy
  has_many :attendances, dependent: :nullify
  accepts_nested_attributes_for :weekly_slots

  after_create :associate_existing_attendances

  private

  def associate_existing_attendances
    # Associate existing attendances for this week with this weekly goal
    user.attendances
        .where("attendance_date >= ? AND attendance_date <= ?", week.start_date, week.end_date)
        .where(weekly_goal_id: nil)
        .update_all(weekly_goal_id: id)
  end
end
