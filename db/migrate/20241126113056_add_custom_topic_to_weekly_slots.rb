class AddCustomTopicToWeeklySlots < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:weekly_slots, :custom_topic)
      add_column :weekly_slots, :custom_topic, :string
    end  end
end
