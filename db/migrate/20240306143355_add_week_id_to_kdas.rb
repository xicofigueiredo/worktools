class AddWeekIdToKdas < ActiveRecord::Migration[7.0]
  def change
    add_reference :kdas, :week, null: false, foreign_key: true
  end
end
