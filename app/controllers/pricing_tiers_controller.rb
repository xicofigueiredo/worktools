class PricingTiersController < ApplicationController
  before_action :require_admin_or_admissions

  def index
    @pricing_tiers = PricingTier.all

    # Apply filters
    @pricing_tiers = @pricing_tiers.where(model: params[:model]) if params[:model].present?
    @pricing_tiers = @pricing_tiers.where(country: params[:country]) if params[:country].present?
    @pricing_tiers = @pricing_tiers.where(hub_type: params[:hub_type]) if params[:hub_type].present?
    @pricing_tiers = @pricing_tiers.where(specific_hub: params[:specific_hub]) if params[:specific_hub].present?
    @pricing_tiers = @pricing_tiers.where(curriculum: params[:curriculum]) if params[:curriculum].present?

    @pricing_tiers = @pricing_tiers.order(:model, :country, :hub_type, :curriculum)

    # Get unique values for filters
    @models = PricingTier.distinct.pluck(:model).compact.sort
    @countries = PricingTier.distinct.pluck(:country).compact.sort
    @hub_types = PricingTier.distinct.pluck(:hub_type).compact.sort
    @specific_hubs = PricingTier.distinct.pluck(:specific_hub).compact.sort
    @curriculums = PricingTier.distinct.pluck(:curriculum).compact.sort
  end

  def update
    @pricing_tier = PricingTier.find(params[:id])

    if @pricing_tier.update(pricing_tier_params)
      render json: { success: true, message: 'Pricing tier updated successfully' }
    else
      render json: { success: false, errors: @pricing_tier.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def pricing_tier_params
    params.require(:pricing_tier).permit(
      :admission_fee,
      :monthly_fee,
      :renewal_fee,
      :invoice_recipient,
      :notes
    )
  end

  def require_admin_or_admissions
    unless current_user.admin? || current_user.admissions?
      redirect_to root_path, alert: 'Access denied: Admins or admissions users only.'
    end
  end
end
