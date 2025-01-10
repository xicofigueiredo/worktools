class AddSkillAndCommunityReferencesToReportActivities < ActiveRecord::Migration[7.0]
  def change
    add_reference :report_activities, :skill, foreign_key: true
    add_reference :report_activities, :community, foreign_key: true
  end
end
