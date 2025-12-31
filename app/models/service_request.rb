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

  def handle_confirmation_update(confirmation)
    if confirmation.status == 'approved'
      chain = approval_chain
      next_index = chain.index(confirmation.approver).to_i + 1

      if next_index < chain.length
        # Move to the next person in the chain
        confirmations.create!(type: 'Confirmation', approver: chain[next_index], status: 'pending')
      else
        # No more approvers, final approval
        update!(status: 'approved')
      end
    elsif confirmation.status == 'rejected'
      update!(status: 'rejected')
    end
  end

  def create_initial_confirmation
    chain = approval_chain
    if chain.present?
      confirmations.create!(type: 'Confirmation', approver: chain.first, status: 'pending')
    else
      update!(status: 'approved')
    end
  end
end
