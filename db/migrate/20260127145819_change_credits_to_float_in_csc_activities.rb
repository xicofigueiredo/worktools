class ChangeCreditsToFloatInCscActivities < ActiveRecord::Migration[7.0]
  def change
    change_column :csc_activities, :credits, :decimal, precision: 3, scale: 2
  end
end
