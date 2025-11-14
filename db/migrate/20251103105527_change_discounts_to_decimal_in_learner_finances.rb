class ChangeDiscountsToDecimalInLearnerFinances < ActiveRecord::Migration[6.0]
  def up
    change_column :learner_finances, :discount_mf, 'numeric(6,2)', using: 'discount_mf::numeric(6,2)'
    change_column :learner_finances, :discount_af, 'numeric(6,2)', using: 'discount_af::numeric(6,2)'
    change_column :learner_finances, :discount_rf, 'numeric(6,2)', using: 'discount_rf::numeric(6,2)'
  end

  def down
    change_column :learner_finances, :discount_mf, 'integer', using: 'round(discount_mf)::integer'
    change_column :learner_finances, :discount_af, 'integer', using: 'round(discount_af)::integer'
    change_column :learner_finances, :discount_rf, 'integer', using: 'round(discount_rf)::integer'
  end
end
