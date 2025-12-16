class CreateHubBookingSystem < ActiveRecord::Migration[7.0]
  def change
    # 1. Configuration Table
    create_table :hub_booking_configs do |t|
      t.references :hub, null: false, foreign_key: true
      t.integer :visit_days, array: true, default: []
      t.string :visit_slots, array: true, default: []
      t.integer :visit_duration, default: 60
      t.integer :trial_duration, default: 180
      t.timestamps
    end

    # 2. Visits Table
    create_table :hub_visits do |t|
      t.references :hub, null: false, foreign_key: true
      t.string :visit_type, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.string :status, default: 'pending', null: false

      # Visitor Details
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :learner_name
      t.string :learner_age
      t.string :learner_academic_level
      t.text :special_requests

      t.timestamps
    end

    add_index :hub_visits, [:hub_id, :start_time, :end_time]
  end
end
