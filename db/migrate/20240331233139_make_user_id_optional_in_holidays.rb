class MakeUserIdOptionalInHolidays < ActiveRecord::Migration[7.0]
  def change
    change_column_null :holidays, :user_id, true
  end
end
