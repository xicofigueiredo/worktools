class ServiceRequest < ApplicationRecord
  # Single Table Inheritance Parent

  belongs_to :requester, class_name: 'User'
  belongs_to :learner, class_name: 'User'

  # Reusing your existing Confirmation system
  has_many :confirmations, as: :confirmable, dependent: :destroy

  validates :status, inclusion: { in: %w[pending approved rejected cancelled] }
  validates :reason, presence: true

  # Placeholder: The prompt requested an empty array for now
  def approval_chain
    []
  end

  # Interface for child classes to implement if needed
  def handle_confirmation_update(confirmation)
    if confirmation.status == 'approved'
      # Logic to move to next approver or finalize
      update(status: 'approved')
    elsif confirmation.status == 'rejected'
      update(status: 'rejected')
    end
  end
end
