class SetupExamSeason < ApplicationRecord
  validates :season_name, :start_date, :end_date, presence: true

  # Finds or builds the settings record for a given Sprint season hash
  # (e.g. the hashes returned by Sprint.current_season / find_season_for_date)
  def self.for_season(season_hash)
    return nil unless season_hash

    find_or_initialize_by(
      start_date: season_hash[:start_date],
      end_date: season_hash[:end_date]
    ) do |record|
      record.season_name ||= season_hash[:name]
    end
  end
end
