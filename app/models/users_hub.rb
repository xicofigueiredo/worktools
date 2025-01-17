class UsersHub < ApplicationRecord
  belongs_to :user
  belongs_to :hub

  validates :main, uniqueness: { scope: :user_id, message: 'Only one hub can be marked as main for a user' }

end
