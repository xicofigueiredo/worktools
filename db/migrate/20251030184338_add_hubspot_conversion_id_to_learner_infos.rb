class AddHubspotConversionIdToLearnerInfos < ActiveRecord::Migration[7.0]
  def change
    add_column :learner_infos, :hubspot_conversion_id, :string
  end
end
