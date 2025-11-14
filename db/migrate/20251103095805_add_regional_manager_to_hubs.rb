class AddRegionalManagerToHubs < ActiveRecord::Migration[7.0]
  def change
    add_reference :hubs, :regional_manager, foreign_key: { to_table: :users }, index: true
  end
end
