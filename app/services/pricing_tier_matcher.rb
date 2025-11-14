class PricingTierMatcher
  def self.for_learner(learner_info, curriculum = nil, hub = nil, programme = nil)
    # Use provided values or fallback to learner's current values
    target_curriculum = curriculum || learner_info.curriculum_course_option
    target_hub = hub || get_main_hub_for_learner(learner_info)
    target_programme = target_hub.hub_type == 'Online' ? 'Online' : 'Hybrid'

    Rails.logger.info("PricingTierMatcher - Looking for pricing:")
    Rails.logger.info("  Curriculum: #{target_curriculum}")
    Rails.logger.info("  Hub: #{target_hub&.name}")
    Rails.logger.info("  Programme: #{target_programme}")

    return nil unless target_hub && target_curriculum.present? && target_programme.present?

    country = target_hub.country
    Rails.logger.info("  Country: #{country}")

    # Curriculum alias mapping for pricing search
    curriculum_aliases = {
      "UP Sports Exercise" => "UP Sports & Leisure",
      "UP Sports Management" => "UP Sports & Leisure",
      "ESL Course" => "Own Curriculum",
      "UPx Business" => "UP Business"
    }

    search_curriculum = curriculum_aliases[target_curriculum] || target_curriculum
    Rails.logger.info("  Search Curriculum: #{search_curriculum}")

    # PRIORITY 1: Try exact match with specific_hub
    pricing = PricingTier.find_by(
      model: target_programme,
      country: country,
      curriculum: search_curriculum,
      specific_hub: target_hub.name
    )

    if pricing
      Rails.logger.info("✓ Found pricing tier with specific_hub: #{target_hub.name}")
      return pricing
    end

    # PRIORITY 2: Try with hub_type if available (MORE SPECIFIC FALLBACK)
    if target_hub.hub_type.present?
      pricing = PricingTier.find_by(
        model: target_programme,
        country: country,
        curriculum: search_curriculum,
        hub_type: target_hub.hub_type,
        specific_hub: "N/A"
      )

      if pricing
        Rails.logger.info("✓ Found pricing tier with hub_type: #{target_hub.hub_type}")
        return pricing
      end
    end

    # PRIORITY 3: Try with specific_hub = "N/A" (GENERIC FALLBACK)
    pricing = PricingTier.find_by(
      model: target_programme,
      country: country,
      curriculum: search_curriculum,
      specific_hub: "N/A"
    )

    if pricing
      Rails.logger.info("✓ Found pricing tier with specific_hub: N/A")
      return pricing
    end

    Rails.logger.warn("✗ No pricing tier found for the given criteria")
    nil
  end

  def self.get_main_hub_for_learner(learner_info)
    # First check if learner has a direct hub_id
    return learner_info.hub if learner_info.hub_id.present?

    # Fall back to user's main hub
    return nil unless learner_info.user_id.present?

    users_hub = UsersHub.includes(:hub).find_by(user_id: learner_info.user_id, main: true)
    users_hub&.hub
  end
end
