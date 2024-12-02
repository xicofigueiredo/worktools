class AddLearningCoachRubricFieldsToReports < ActiveRecord::Migration[7.0]
  def change
    add_column :reports, :sdl_long_term_plans, :integer
    add_column :reports, :sdl_week_organization, :integer
    add_column :reports, :sdl_achieve_goals, :integer
    add_column :reports, :sdl_study_techniques, :integer
    add_column :reports, :sdl_initiative_office_hours, :integer
    add_column :reports, :ini_new_activities, :integer
    add_column :reports, :ini_goal_setting, :integer
    add_column :reports, :mot_integrity, :integer
    add_column :reports, :mot_improvement, :integer
    add_column :reports, :p2p_support_from_peers, :integer
    add_column :reports, :p2p_support_to_peers, :integer
    add_column :reports, :hub_cleanliness, :integer
    add_column :reports, :hub_respectful_behavior, :integer
    add_column :reports, :hub_welcome_others, :integer
    add_column :reports, :hub_participation, :integer
  end
end
