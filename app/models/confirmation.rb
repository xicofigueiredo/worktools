class Confirmation < ApplicationRecord
  belongs_to :staff_leave
  belongs_to :approver, class_name: 'User'

  STATUSES = %w[pending approved rejected].freeze
  validates :status, inclusion: { in: STATUSES }

  after_create :notify_approver
  after_update :update_staff_leave_status

  scope :pending, -> { where(status: 'pending') }

  def reminder_sent_at?(days)
    case days
    when 3
      reminder_3_sent_at.present?
    when 5
      reminder_5_sent_at.present?
    else
      false
    end
  end

  private

  def notify_approver
    # only notify when a pending confirmation is created and we have an approver
    return unless status == 'pending' && approver.present?

    # build a link to manager pending confirmations view; anchor to the confirmation row
    # use path (relative) so it works in dev/prod without host config
    begin
      link = Rails.application.routes.url_helpers.leaves_path(active_tab: 'manager') + "#confirmation-#{id}"
    rescue => e
      # fallback simple path in case route helpers are not available for some reason
      link = "/leaves?active_tab=manager#confirmation-#{id}"
      Rails.logger.warn "Confirmation#notify_approver: route helper failed: #{e.class} #{e.message}"
    end

    message = "You have a new leave request pending for #{staff_leave.user.full_name}: #{staff_leave.start_date} → #{staff_leave.end_date}."

    # create the notification if it doesn't exist already (avoid duplicates)
    Notification.find_or_create_by!(user: approver, link: link, message: message)
  rescue => e
    Rails.logger.error "Confirmation#notify_approver error: #{e.class} #{e.message}\n#{e.backtrace.first(8).join("\n")}"
  end


  def update_staff_leave_status
    leave = staff_leave

    # --- CLEANUP: remove the notification that was created for this confirmation (best-effort)
    begin
      link = Rails.application.routes.url_helpers.leaves_path(active_tab: 'manager') + "#confirmation-#{id}"
      Notification.where(user: approver, link: link).update!(read: true)
    rescue => e
      Rails.logger.warn "Confirmation#cleanup_notification failed for confirmation=#{id}: #{e.class} #{e.message}"
    end

    if status == 'rejected'
      # For regular confirmations: mark leave rejected
      # For cancellation confirmations: rejection means the cancellation was refused (leave remains as-is)
      leave.update(status: 'rejected') unless self.is_a?(CancellationConfirmation)
    elsif status == 'approved'
      if self.is_a?(CancellationConfirmation)
        # Propagate cancellation approvals along the approval chain.
        chain = leave.approval_chain
        # try to find approver index; if not found, treat as starting at first
        idx = chain.index(approver) || 0

        if idx < (chain.length - 1)
          # Ask the next manager in the chain to approve the cancellation
          next_approver = chain[idx + 1]
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
