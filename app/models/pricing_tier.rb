class PricingTier < ApplicationRecord
  belongs_to :hub, optional: true

  # Validations
  validates :model, :country, :hub_type, :curriculum, :year, presence: true
  validates :monthly_fee, :admission_fee, :renewal_fee, numericality: { greater_than_or_equal_to: 0 }

  # Constants
  CURRENCY_MAPPING = {
    'Portugal' => '€',
    'Mozambique' => 'MZN',
    'Kenya' => 'KSh',
    'Namibia' => '$N',
    'South Africa' => 'R',
    'Spain' => '€',
    'Region 1' => '$',
    'Region 2' => '$',
    'Region 3' => '$'
  }.freeze

  # Helper to get currency dynamically
  def currency_symbol
    CURRENCY_MAPPING[country] || '€'
  end

  # Scopes for easier filtering
  scope :for_year, ->(year) { where(year: year) }
  scope :active, -> { where(year: Date.today.year) }
end
