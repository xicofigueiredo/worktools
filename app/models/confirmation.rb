class Confirmation < ApplicationRecord
  belongs_to :staff_leave
  belongs_to :approver, class_name: 'User'

  STATUSES = %w[pending approved rejected].freeze
  validates :status, inclusion: { in: STATUSES }

  after_update :update_staff_leave_status

  scope :pending, -> { where(status: 'pending') }

  def update_staff_leave_status
    leave = staff_leave

    if status == 'rejected'
      # For regular confirmations: mark leave rejected
      # For cancellation confirmations: rejection means the cancellation was refused (leave remains as-is)
      leave.update(status: 'rejected') unless self.is_a?(CancellationConfirmation)
    elsif status == 'approved'
      if self.is_a?(CancellationConfirmation)
        # Get the list of approvers who have approved the original leave
        approved_confs = leave.confirmations.where(status: 'approved', type: 'Confirmation').order(:updated_at)
        approved_approvers = approved_confs.map(&:approver)
        # Find the index of the current approver in the approved list
        idx = approved_approvers.index(approver) || 0

        if idx < (approved_approvers.length - 1)
          # Ask the next manager who approved the original leave to approve the cancellation
          next_approver = approved_approvers[idx + 1]
          leave.confirmations.create!(type: 'CancellationConfirmation', approver: next_approver, status: 'pending')
        else
          # Last approver approved cancellation -> cancel the leave
          leave.update(status: 'cancelled')
        end
      else
        # Normal approval chain for creating approvals
        chain = leave.approval_chain
        next_index = chain.index(approver) + 1
        if next_index < chain.length
          leave.confirmations.create!(type: 'Confirmation', approver: chain[next_index], status: 'pending')
        else
          leave.update(status: 'approved')
        end
      end
    end
  end
end
