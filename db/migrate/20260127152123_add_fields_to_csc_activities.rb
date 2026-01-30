class AddFieldsToCscActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :csc_activities, :full_name, :string
    add_column :csc_activities, :date_of_submission, :date
    add_column :csc_activities, :expected_hours, :integer
    add_column :csc_activities, :tags, :text, array: true, default: []
    add_column :csc_activities, :partner, :string
    add_column :csc_activities, :activity_description, :text
    add_column :csc_activities, :reflection, :text
    add_column :csc_activities, :unpaid, :boolean, default: false
    add_column :csc_activities, :not_academic, :boolean, default: false
    add_column :csc_activities, :time_investment, :boolean, default: false
    add_column :csc_activities, :evidence, :boolean, default: false
    add_column :csc_activities, :review_date, :date
    add_column :csc_activities, :reviewed_by, :string
    add_column :csc_activities, :notes, :text
    add_column :csc_activities, :domain, :integer
    add_column :csc_activities, :planing, :integer
    add_column :csc_activities, :effort, :integer
    add_column :csc_activities, :skill, :integer
    add_column :csc_activities, :community, :integer
  end
end
