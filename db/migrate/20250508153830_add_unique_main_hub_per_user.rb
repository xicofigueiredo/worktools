class AddUniqueMainHubPerUser < ActiveRecord::Migration[7.0]
  def change
    # Add a partial unique index for main: true only
    add_index :users_hubs, :user_id, unique: true, where: "main = true", name: "index_users_hubs_on_user_id_main_true"
  end
end
