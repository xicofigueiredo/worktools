class HubTransferRequest < ServiceRequest
  belongs_to :target_hub, class_name: 'Hub'

  validates :target_hub_id, presence: true

  after_update :finalize_transfer!, if: -> { saved_change_to_status?(to: 'approved') }

  def finalize_transfer!
    ActiveRecord::Base.transaction do
      source_hub = learner.learner_info&.hub

      update_admission_record
      rotate_hub_access(source_hub)
      recalculate_finance

      schedule_notification
    end
  end

  private

  def update_admission_record
    if learner.learner_info
      learner.learner_info.update!(hub: target_hub)
    else
      Rails.logger.warn "Transfer Warning: Learner #{learner_id} missing LearnerInfo."
    end
  end

  def rotate_hub_access(source_hub)
    is_main = resolve_main_status(source_hub)

    remove_old_access(source_hub) if source_hub

    UsersHub.create!(user: learner, hub: target_hub, main: is_main)
  end

  def resolve_main_status(source_hub)
    if source_hub
      # If replacing an existing hub, inherit its 'main' status
      old_entry = UsersHub.find_by(user: learner, hub: source_hub)
      old_entry&.main || false
    else
      # If no previous hub, it's main only if they don't have another main hub
      !UsersHub.exists?(user: learner, main: true)
    end
  end

  def remove_old_access(source_hub)
    UsersHub.where(user: learner, hub: source_hub).destroy_all
  end

  def recalculate_finance
    # Placeholder
    Rails.logger.info "TODO: Check pricing change after transfer to #{target_hub.name}"
  end

  def schedule_notification
    # Placeholder
    Rails.logger.info "TODO: Send email to parents about transfer to #{target_hub.name}"
  end
end
