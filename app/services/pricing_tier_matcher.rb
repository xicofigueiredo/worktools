class PricingTierMatcher
  # We now default to the current year (integer)
  def self.for_learner(learner_info, curriculum = nil, hub = nil, year = Date.today.year)
    # 1. Resolve Targets
    target_hub = hub || get_main_hub_for_learner(learner_info)
    target_curriculum = curriculum || learner_info.curriculum_course_option

    # Guard clauses
    unless target_hub && target_curriculum.present?
      Rails.logger.warn("PricingTierMatcher: Missing Hub or Curriculum for Learner #{learner_info.id}")
      return nil
    end

    # 2. Resolve Attributes
    # 'Online' model if hub_type is Online, otherwise 'Hybrid'
    target_model = target_hub.hub_type == 'Online' ? 'Online' : 'Hybrid'

    # Handle Curriculum Aliases (Sanitization)
    search_curriculum = resolve_curriculum_alias(target_curriculum)

    # 3. Log the search criteria (Helpful for debugging)
    Rails.logger.info "Pricing Search: Hub=#{target_hub.name} (#{target_hub.country}), Model=#{target_model}, Curr=#{search_curriculum}, Year=#{year}"

    # --- SEARCH LEVEL 1: Specific Hub ID Match ---
    tier = PricingTier.find_by(
      hub_id: target_hub.id,
      model: target_model,
      curriculum: search_curriculum,
      year: year
    )

    return tier if tier

    # --- SEARCH LEVEL 2: Generic Hub Type Match (Country/Type based) ---
    tier = PricingTier.find_by(
      hub_id: nil,
      country: target_hub.country,
      hub_type: target_hub.hub_type,
      model: target_model,
      curriculum: search_curriculum,
      year: year
    )

    return tier if tier

    Rails.logger.warn("✗ No PricingTier found for #{target_hub.name} / #{search_curriculum} / #{year}")
    nil
  end

  def self.resolve_curriculum_alias(name)
    aliases = {
      "UP Sports Exercise" => "UP Sports & Leisure",
      "UP Sports Management" => "UP Sports & Leisure",
      "ESL Course" => "Own Curriculum",
      "UPx Business" => "UP Business",
      "UP Business (GENEX)" => "UP Business"
    }
    aliases[name] || name
  end

  def self.get_main_hub_for_learner(learner_info)
    return learner_info.hub if learner_info.hub_id.present?
    return nil unless learner_info.user_id.present?

    # Efficiently fetch the main hub
    UsersHub.includes(:hub).find_by(user_id: learner_info.user_id, main: true)&.hub
  end
end
