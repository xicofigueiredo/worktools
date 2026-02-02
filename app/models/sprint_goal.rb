class SprintGoal < ApplicationRecord
  belongs_to :user
  belongs_to :sprint

  has_many :knowledges, dependent: :destroy
  has_many :skills, dependent: :destroy
  has_many :communities, class_name: 'Community', dependent: :destroy
  has_many :csc_activities, as: :activitable, dependent: :destroy

  validates :user, presence: true
  validates :sprint, presence: true

  accepts_nested_attributes_for :knowledges, allow_destroy: true
  accepts_nested_attributes_for :skills, allow_destroy: true
  accepts_nested_attributes_for :communities, allow_destroy: true

  after_create :create_build_week_activity
  after_create :create_hub_activities_activity
  after_update :check_build_week_hub_activities

  private

  def create_build_week_activity
    csc_diploma = user.csc_diploma || user.create_csc_diploma
    return unless csc_diploma.present?

    CscActivity.create(
      csc_diploma: csc_diploma,
      activitable: self,
      full_name: user.full_name,
      date_of_submission: created_at,
      activity_name: "Build Week",
      activity_type: "build_week",
      extra: 1.0,
      start_date: sprint.start_date,
      end_date: sprint.end_date
    )
  end

  def create_hub_activities_activity
    csc_diploma = user.csc_diploma || user.create_csc_diploma
    return unless csc_diploma.present?

    CscActivity.create(
      csc_diploma: csc_diploma,
      activitable: self,
      full_name: user.full_name,
      date_of_submission: created_at,
      activity_name: "Hub Activities",
      activity_type: "hub_activities",
      extra: 1.0,
      start_date: sprint.start_date,
      end_date: sprint.end_date
    )
  end

  def check_build_week_hub_activities
    csc_diploma = user.csc_diploma
    return unless csc_diploma.present?

    activity_count = csc_diploma.csc_activities.where(activitable: self).count
    if activity_count < 2
      create_build_week_activity unless csc_diploma.csc_activities.exists?(activitable: self, activity_type: "build_week")
      create_hub_activities_activity unless csc_diploma.csc_activities.exists?(activitable: self, activity_type: "hub_activities")
    end
  end
end
