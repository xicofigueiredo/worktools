class AddLevelToLwsTimelines < ActiveRecord::Migration[7.0]
  def change
    add_column :lws_timelines, :level, :string
  end
end
