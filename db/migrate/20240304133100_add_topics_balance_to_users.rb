class AddTopicsBalanceToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :topics_balance, :integer, default: 0
  end
end
