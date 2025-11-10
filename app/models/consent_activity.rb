class ConsentActivity < ApplicationRecord
  belongs_to :week, optional: true
  belongs_to :hub, optional: true
end
