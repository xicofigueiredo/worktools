class AddColorToTimelines < ActiveRecord::Migration[7.0]
  def change
    add_column :timelines, :color, :string, default: '#F4F4F4'

    reversible do |dir|
      dir.up do
        Timeline.update_all(color: '#F4F4F4')
      end
    end
  end
end
