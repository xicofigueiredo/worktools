class SyncOutlookEventJob < ApplicationJob
  queue_as :default

  def perform(visit_id)
    visit = HubVisit.find(visit_id)

    return if ['cancelled', 'rejected'].include?(visit.status)

    result = MicrosoftGraphService.new.create_event(visit)

    if result && result['id']
      visit.update_column(:outlook_event_id, result['id'])
    else
      Rails.logger.error("Failed to sync HubVisit #{visit_id} to Outlook.")
    end
  end
end
