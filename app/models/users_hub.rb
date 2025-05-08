class UsersHub < ApplicationRecord
  belongs_to :user
  belongs_to :hub

# app/models/users_hub.rb
validates :main, uniqueness: { scope: :user_id, message: 'Only one hub can be marked as main for a user' }, if: :main?
end
