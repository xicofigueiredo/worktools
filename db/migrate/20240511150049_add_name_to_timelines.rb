class AddNameToTimelines < ActiveRecord::Migration[7.0]
  def change
    add_column :timelines, :personalized_name, :string
  end
end
