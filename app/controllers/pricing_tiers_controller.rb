class PricingTiersController < ApplicationController
  before_action :require_admin_or_admissions

  def index
    # 1. Setup Navigation Options
    @years = PricingTier.distinct.pluck(:year).compact.sort.reverse
    @countries = PricingTier.distinct.pluck(:country).compact.sort

    # 2. Determine Current Year & Country (Default to latest/first)
    @selected_year = params[:year].present? ? params[:year].to_i : @years.first
    @selected_country = params[:country].presence || @countries.first

    # 3. Fetch Available Hubs for this specific context
    context_tiers = PricingTier.where(year: @selected_year, country: @selected_country)

    # Build a clean list of options: { type, hub_id, name }
    @available_hubs = context_tiers.pluck(:hub_type, :hub_id).uniq.map do |type, hub_id|
      name = hub_id ? Hub.find(hub_id).name : type
      { type: type, hub_id: hub_id, name: name }
    end.sort_by { |h| h[:name] }

    # 4. Determine Selected Hub
    #    If user clicked a specific hub, use it. Otherwise, default to the first available option.
    requested_hub_exists = @available_hubs.any? do |h|
      h[:hub_id].to_s == params[:hub_id].to_s && h[:type] == params[:hub_type]
    end

    if requested_hub_exists
      # If the hub from the URL is valid for this country, keep it.
      @selected_hub_id = params[:hub_id]
      @selected_hub_type = params[:hub_type]
    else
      # If the hub from the URL is NOT valid (or no hub selected), default to the first available.
      default_hub = @available_hubs.first
      if default_hub
        @selected_hub_id = default_hub[:hub_id]
        @selected_hub_type = default_hub[:type]
      end
    end

    # 5. Fetch Matrix Data
    # Query specific tiers based on the 3 active filters
    query = PricingTier.where(
      year: @selected_year,
      country: @selected_country,
      hub_type: @selected_hub_type,
      hub_id: @selected_hub_id
    )

    @matrix_tiers = query.index_by(&:curriculum)
    @curriculums = @matrix_tiers.keys.sort
  end

  def update
    @pricing_tier = PricingTier.find(params[:id])

    # Allow updating year and fees
    if @pricing_tier.update(pricing_tier_params)
      render json: {
        success: true,
        message: 'Pricing tier updated successfully',
        formatted_admission: @pricing_tier.admission_fee,
        formatted_monthly: @pricing_tier.monthly_fee,
        formatted_renewal: @pricing_tier.renewal_fee
      }
    else
      render json: { success: false, errors: @pricing_tier.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def pricing_tier_params
    params.require(:pricing_tier).permit(
      :admission_fee, :monthly_fee, :renewal_fee,
      :invoice_recipient, :notes, :year
    )
  end

  def require_admin_or_admissions
    unless current_user.admin? || current_user.admissions?
      redirect_to root_path, alert: 'Access denied.'
    end
  end
end
