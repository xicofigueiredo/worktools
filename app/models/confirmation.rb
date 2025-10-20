class Confirmation < ApplicationRecord
  belongs_to :confirmable, polymorphic: true
  belongs_to :approver, class_name: 'User'

  STATUSES = %w[pending approved rejected].freeze
  validates :status, inclusion: { in: STATUSES }

  after_update :update_confirmable_status

  scope :pending, -> { where(status: 'pending') }

  private

  def update_confirmable_status
    confirmable.handle_confirmation_update(self)
  end
end
