class AddLinkToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :link, :string
  end
end
