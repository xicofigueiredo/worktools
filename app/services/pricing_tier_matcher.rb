class PricingTierMatcher
  def self.for_learner(learner_info, curriculum = nil, hub = nil, programme = nil)
    # Use provided curriculum or fallback to learner's current curriculum
    target_curriculum = curriculum || learner_info.curriculum_course_option

    # Get the hub - either provided or fetch from learner's main hub
    target_hub = hub || get_main_hub_for_learner(learner_info)

    return nil unless target_hub && target_curriculum.present?

    # Determine model based on programme (priority) or hub
    model = if programme&.start_with?('Online:')
      'Online'
    elsif programme&.start_with?('In-Person:')
      'Hybrid'
    else
      target_hub.name.downcase == 'remote' ? 'online' : 'hybrid'
    end

    Rails.logger.info("INFO #{model}, #{target_hub.country}, #{target_curriculum}, #{target_hub.name}")

    # Try to find pricing tier with exact match including specific_hub
    pricing = PricingTier.find_by(
      model: model,
      country: target_hub.country,
      curriculum: target_curriculum,
      specific_hub: target_hub.name
    )

    # Fallback: try without specific_hub if not found
    pricing ||= PricingTier.find_by(
      model: model,
      country: target_hub.country,
      curriculum: target_curriculum,
      specific_hub: "N/A"
    )

    # Fallback: try with hub_type if that's set
    if pricing.nil? && target_hub.hub_type.present?
      pricing = PricingTier.find_by(
        model: model,
        country: target_hub.country,
        curriculum: target_curriculum,
        hub_type: target_hub.hub_type,
        specific_hub: "N/A"
      )
    end

    pricing
  end

  def self.get_main_hub_for_learner(learner_info)
    return nil unless learner_info.user_id.present?

    users_hub = UsersHub.includes(:hub).find_by(user_id: learner_info.user_id, main: true)
    users_hub&.hub
  end
end
