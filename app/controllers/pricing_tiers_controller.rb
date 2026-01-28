class PricingTiersController < ApplicationController
  before_action :require_admin_or_admissions

  def index
    # Eager load the Hub relation to avoid N+1 queries
    @pricing_tiers = PricingTier.includes(:hub).all

    # 1. Year Filter (Integer)
    @pricing_tiers = @pricing_tiers.where(year: params[:year]) if params[:year].present?

    # 2. Hub Filter (Using ID now, not string name)
    if params[:hub_id].present?
      @pricing_tiers = @pricing_tiers.where(hub_id: params[:hub_id])
    end

    # 3. Handle "Generic" (No Specific Hub)
    if params[:generic_only] == 'true'
      @pricing_tiers = @pricing_tiers.where(hub_id: nil)
    end

    # Standard filters
    @pricing_tiers = @pricing_tiers.where(model: params[:model]) if params[:model].present?
    @pricing_tiers = @pricing_tiers.where(country: params[:country]) if params[:country].present?
    @pricing_tiers = @pricing_tiers.where(hub_type: params[:hub_type]) if params[:hub_type].present?
    @pricing_tiers = @pricing_tiers.where(curriculum: params[:curriculum]) if params[:curriculum].present?

    # Sort by Year desc, then Country
    @pricing_tiers = @pricing_tiers.order(year: :desc, country: :asc, model: :asc)

    # --- Setup Dropdowns for View ---
    @years = PricingTier.distinct.pluck(:year).compact.sort.reverse
    @models = PricingTier.distinct.pluck(:model).compact.sort
    @countries = PricingTier.distinct.pluck(:country).compact.sort
    @hub_types = PricingTier.distinct.pluck(:hub_type).compact.sort
    @curriculums = PricingTier.distinct.pluck(:curriculum).compact.sort

    # Fetch Hubs that actually have specific pricing tiers
    existing_hub_ids = PricingTier.where.not(hub_id: nil).distinct.pluck(:hub_id)
    @specific_hubs = Hub.where(id: existing_hub_ids).order(:name).pluck(:name, :id)
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
