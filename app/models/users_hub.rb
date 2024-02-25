class UsersHub < ApplicationRecord
  belongs_to :user
  belongs_to :hub
end
