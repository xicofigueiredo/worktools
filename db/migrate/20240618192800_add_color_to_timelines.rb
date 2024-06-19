class AddColorToTimelines < ActiveRecord::Migration[7.0]
  def change
    add_column :timelines, :color, :string, default: '#FFFFFF'

    reversible do |dir|
      dir.up do
        Timeline.update_all(color: '#FFFFFF')
      end
    end
  end
end
