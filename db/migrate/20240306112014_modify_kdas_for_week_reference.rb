class ModifyKdasForWeekReference < ActiveRecord::Migration[7.0]
  def change
    def change
      remove_column :kdas, :start_date, :date
      remove_column :kdas, :end_date, :date
      add_reference :kdas, :week, null: false, foreign_key: true
    end
  end
end
