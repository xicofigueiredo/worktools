class CreateCreateLearnerFinances < ActiveRecord::Migration[7.0]
  def up
    # Create the new learner_finances table
    create_table :learner_finances do |t|
      t.references :learner_info, null: false, foreign_key: true, index: true
      t.string "payment_plan"
      t.integer "monthly_fee"
      t.integer "discount_mf"
      t.integer "scholarship"
      t.integer "billable_mf"
      t.integer "admission_fee"
      t.integer "discount_af"
      t.integer "billable_af"
      t.integer "renewal_fee"
      t.integer "discount_rf"
      t.integer "billable_rf"
      t.timestamps
    end

    # Remove columns from learner_infos
    remove_column :learner_infos, :deposit, :string
    remove_column :learner_infos, :sponsor, :string
    remove_column :learner_infos, :payment_plan, :string
    remove_column :learner_infos, :monthly_tuition, :integer
    remove_column :learner_infos, :discount_mt, :string
    remove_column :learner_infos, :scholarship, :string
    remove_column :learner_infos, :billable_fee_per_month, :integer
    remove_column :learner_infos, :scholarship_percentage, :integer
    remove_column :learner_infos, :admission_fee, :integer
    remove_column :learner_infos, :discount_af, :integer
    remove_column :learner_infos, :billable_af, :integer
    remove_column :learner_infos, :registration_renewal, :integer
  end

  def down
    # Add columns back to learner_infos
    add_column :learner_infos, :deposit, :string
    add_column :learner_infos, :sponsor, :string
    add_column :learner_infos, :payment_plan, :string
    add_column :learner_infos, :monthly_tuition, :integer
    add_column :learner_infos, :discount_mt, :string
    add_column :learner_infos, :scholarship, :string
    add_column :learner_infos, :billable_fee_per_month, :integer
    add_column :learner_infos, :scholarship_percentage, :integer
    add_column :learner_infos, :admission_fee, :integer
    add_column :learner_infos, :discount_af, :integer
    add_column :learner_infos, :billable_af, :integer
    add_column :learner_infos, :registration_renewal, :integer

    drop_table :learner_finances
  end

  private

  def parse_discount(value)
    return nil if value.nil? || value.to_s.strip.empty?
    value.to_s.gsub(/[^\d\-]/, '').to_i
  end

  def parse_scholarship(value)
    return nil if value.nil? || value.to_s.strip.empty?
    value.to_s.gsub(/[^\d\-]/, '').to_i
  end
end
