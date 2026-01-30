class PricingTiersController < ApplicationController
  before_action :require_admin_or_admissions

  def index
    # Setup Navigation
    @years = PricingTier.distinct.pluck(:year).compact.sort.reverse
    @countries = PricingTier.distinct.pluck(:country).compact.sort

    # Defaults
    @selected_year = params[:year].present? ? params[:year].to_i : @years.first
    @selected_country = params[:country].presence || @countries.first

    # Available Hubs
    context_tiers = PricingTier.where(year: @selected_year, country: @selected_country)
    @available_hubs = context_tiers.pluck(:hub_type, :hub_id).uniq.map do |type, hub_id|
      name = hub_id ? Hub.find(hub_id).name : type
      { type: type, hub_id: hub_id, name: name }
    end.sort_by { |h| h[:name] }

    # Determine Active Hub
    requested_hub_exists = @available_hubs.any? do |h|
      h[:hub_id].to_s == params[:hub_id].to_s && h[:type] == params[:hub_type]
    end

    if requested_hub_exists
      @selected_hub_id = params[:hub_id]
      @selected_hub_type = params[:hub_type]
    else
      default_hub = @available_hubs.first
      if default_hub
        @selected_hub_id = default_hub[:hub_id]
        @selected_hub_type = default_hub[:type]
      end
    end

    # Fetch Data
    query = PricingTier.where(
      year: @selected_year,
      country: @selected_country,
      hub_type: @selected_hub_type,
      hub_id: @selected_hub_id
    )

    @matrix_tiers = query.index_by(&:curriculum)
    @curriculums = @matrix_tiers.keys.sort

    # Initialize a dummy object for the shared form
    @shared_tier = PricingTier.new
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

  def pricing_tier_params
    # Permitted parameters
    p = params.require(:pricing_tier).permit(
      :admission_fee, :monthly_fee, :renewal_fee,
      :invoice_recipient, :notes, :year
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
