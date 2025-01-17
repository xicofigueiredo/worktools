class AddMainToUsersHubs < ActiveRecord::Migration[6.1]
  def change
    # Add the main column with default value true
    add_column :users_hubs, :main, :boolean, default: true, null: false

    # Populate the main field
    reversible do |dir|
      dir.up do
        # For each user, ensure only the smallest ID has `main: true`
        UsersHub.select(:user_id).distinct.each do |user_hub|
          user_hubs_for_user = UsersHub.where(user_id: user_hub.user_id).order(:id)
          user_hubs_for_user.offset(1).update_all(main: false) # Keep only the first as true
        end
      end
    end
  end
end
