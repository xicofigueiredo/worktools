class CreateSetupExamSeasons < ActiveRecord::Migration[7.0]
  def change
    create_table :setup_exam_seasons do |t|
      t.string :season_name, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.date :pearson_refund
      t.date :triple_late_fees
      t.date :bga_refund
      t.date :mock_submission_with_extension
      t.date :mock_submission_deadline
      t.date :extension_request_deadline
      t.date :late_registration
      t.date :registration_deadline

      t.timestamps
    end

    add_index :setup_exam_seasons, [:start_date, :end_date]
    add_index :setup_exam_seasons, :season_name
  end
end
