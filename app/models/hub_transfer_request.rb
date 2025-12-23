class HubTransferRequest < ServiceRequest
  belongs_to :target_hub, class_name: 'Hub'

  validates :target_hub_id, presence: true
end
