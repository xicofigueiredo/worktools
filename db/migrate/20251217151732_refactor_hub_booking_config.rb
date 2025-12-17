class RefactorHubBookingConfig < ActiveRecord::Migration[7.0]
  def change
    remove_column :hub_booking_configs, :visit_duration, :integer
    remove_column :hub_booking_configs, :trial_duration, :integer

    remove_column :hub_booking_configs, :visit_slots
    add_column :hub_booking_configs, :visit_slots, :jsonb, default: {}

    remove_column :hub_booking_configs, :visit_days, :integer, array: true if column_exists?(:hub_booking_configs, :visit_days)
  end
end
