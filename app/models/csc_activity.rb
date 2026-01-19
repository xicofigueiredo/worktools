class CscActivity < ApplicationRecord
  belongs_to :csc_diploma
  belongs_to :activitable, polymorphic: true

  validates :activitable_id, uniqueness: { scope: :activitable_type }
end
