class PricingTiersController < ApplicationController
  before_action :require_admin_or_admissions

  def index
    prepare_navigation_data

    prepare_create_modal_data

    set_current_context

    fetch_matrix_data

    # Initialize Forms
    @new_tier = PricingTier.new(
      year: @selected_year,
      country: @selected_country,
      hub_type: @selected_hub_type,
      hub_id: @selected_hub_id
    )
    @shared_tier = PricingTier.new
  end

  def create
    @pricing_tier = PricingTier.new(pricing_tier_params)

    if @pricing_tier.hub_id.present?
      hub = Hub.find_by(id: @pricing_tier.hub_id)
      @pricing_tier.hub_type = hub.hub_type if hub
    end

    @pricing_tier.model ||= "Hybrid"

    if params[:pricing_scope] == "generic"
       @pricing_tier.hub_id = nil
    end

    if @pricing_tier.save
      flash[:notice] = "Pricing tier created successfully."
      # Redirect to the new tier's location so the user sees it immediately
      redirect_to pricing_tiers_path(
        year: @pricing_tier.year,
        country: @pricing_tier.country,
        hub_type: @pricing_tier.hub_type,
        hub_id: @pricing_tier.hub_id
      )
    else
      flash[:alert] = "Error creating tier: #{@pricing_tier.errors.full_messages.join(', ')}"
      redirect_to pricing_tiers_path
    end
  end

  def destroy
    @pricing_tier = PricingTier.find(params[:id])

    # Capture context before deleting
    year = @pricing_tier.year
    country = @pricing_tier.country
    hub_type = @pricing_tier.hub_type
    hub_id = @pricing_tier.hub_id

    # Destroy the record
    if @pricing_tier.destroy
      flash[:notice] = "Pricing tier for #{@pricing_tier.curriculum} deleted successfully."
    else
      flash[:alert] = "Failed to delete pricing tier."
    end

    # Check if data still exists for the current selection, otherwise bubble up.
    if PricingTier.where(year: year, country: country, hub_type: hub_type, hub_id: hub_id).exists?
      # The Hub still has other items. Stay exactly where we are.
      redirect_to pricing_tiers_path(year: year, country: country, hub_type: hub_type, hub_id: hub_id)
    elsif PricingTier.where(year: year, country: country).exists?
      # The Hub is empty, but the Country still has data. Redirect to the Country.
      redirect_to pricing_tiers_path(year: year, country: country)
    elsif PricingTier.where(year: year).exists?
      # The Country is entirely empty. Redirect to the Year.
      redirect_to pricing_tiers_path(year: year)
    else
      # The entire Year is empty. Just go home.
      redirect_to pricing_tiers_path
    end
  end

  def update
    @pricing_tier = PricingTier.find(params[:id])

    # Capture context to return to the exact same view
    redirect_params = {
      year: @pricing_tier.year,
      country: @pricing_tier.country,
      hub_type: @pricing_tier.hub_type,
      hub_id: @pricing_tier.hub_id
    }

    # Update and Redirect
    if @pricing_tier.update(pricing_tier_params)
      redirect_to pricing_tiers_path(redirect_params), notice: "Pricing for #{@pricing_tier.curriculum} updated successfully."
    else
      redirect_to pricing_tiers_path(redirect_params), alert: "Error updating pricing: #{@pricing_tier.errors.full_messages.join(', ')}"
    end
  end

  private

  def prepare_navigation_data
    # Only countries that actually have data (for the Sidebar)
    @sidebar_countries = PricingTier.distinct.pluck(:country).compact.sort
    @years = PricingTier.distinct.pluck(:year).compact.sort
  end

  def prepare_create_modal_data
    # 1. All potential countries (Pricing + Hubs)
    tier_countries = PricingTier.distinct.pluck(:country)
    hub_countries = Hub.distinct.pluck(:country)
    @create_countries = (tier_countries + hub_countries).compact.map(&:strip).uniq.sort

    # 2. Specific Hubs by Country (NORMALIZED KEYS)
    # We strip the country name to ensure it matches the dropdown value exactly
    all_hubs = Hub.order(:name).all
    @hubs_by_country = all_hubs.group_by { |h| h.country.strip }
                               .transform_values { |hubs| hubs.map { |h| [h.name, h.id] } }

    # 3. Hub Types by Country (NORMALIZED KEYS)
    types_from_hubs = Hub.distinct.pluck(:country, :hub_type)
    types_from_tiers = PricingTier.distinct.pluck(:country, :hub_type)

    @hub_types_by_country = (types_from_hubs + types_from_tiers).each_with_object(Hash.new { |h, k| h[k] = [] }) do |(country, type), acc|
      acc[country.strip] << type # Strip keys here too
    end.transform_values { |types| types.compact.map(&:strip).uniq.sort }

    # 4. Currency Mapping (For JS)
    @currency_mapping = PricingTier::CURRENCY_MAPPING

    # Curriculums list
    @curriculum_list = PricingTier.distinct.pluck(:curriculum).compact.sort
  end

  def set_current_context
    @selected_year = params[:year].present? ? params[:year].to_i : @years.first

    # Default country: param -> first sidebar -> first available
    @selected_country = params[:country].presence || @sidebar_countries.first || @create_countries.first
  end

  def fetch_matrix_data
    # 1. Fetch available tabs (Hubs) for this Country/Year
    context_tiers = PricingTier.where(year: @selected_year, country: @selected_country)

    @available_hubs = context_tiers.pluck(:hub_type, :hub_id).uniq.map do |type, hub_id|
      name = hub_id ? Hub.find(hub_id).name : type
      { type: type, hub_id: hub_id, name: name }
    end.sort_by { |h| h[:name] }

    # 2. Determine Active Tab
    requested_hub_exists = @available_hubs.any? do |h|
      h[:hub_id].to_s == params[:hub_id].to_s && h[:type] == params[:hub_type]
    end

    if requested_hub_exists
      @selected_hub_id = params[:hub_id]
      @selected_hub_type = params[:hub_type]
    else
      default = @available_hubs.first
      if default
        @selected_hub_id = default[:hub_id]
        @selected_hub_type = default[:type]
      end
    end

    # 3. Query the actual Table Data
    query = PricingTier.where(
      year: @selected_year,
      country: @selected_country,
      hub_type: @selected_hub_type,
      hub_id: @selected_hub_id
    )

    @matrix_tiers = query.index_by(&:curriculum)
    @curriculums = @matrix_tiers.keys.sort
  end

  def pricing_tier_params
    # Permitted parameters
    p = params.require(:pricing_tier).permit(
      :admission_fee, :monthly_fee, :renewal_fee,
      :invoice_recipient, :notes, :year,
      :country, :hub_type, :hub_id, :curriculum, :model
    )

    # Convert empty strings to nil to avoid "Not a Number" errors
    [:admission_fee, :monthly_fee, :renewal_fee].each do |field|
      p[field] = nil if p[field].blank?
    end

    p
  end

  def require_admin_or_admissions
    unless current_user.admin? || current_user.admissions?
      redirect_to root_path, alert: 'Access denied.'
    end
  end
end
