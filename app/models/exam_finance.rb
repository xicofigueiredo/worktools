class ExamFinance < ApplicationRecord
  belongs_to :user
  has_many :specific_papers, dependent: :destroy

  validates :total_cost, presence: true, numericality: true
  validates :number_of_subjects, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  attr_accessor :changed_by_user_email

  before_save :log_status_change, if: :status_changed?

  def update_number_of_subjects(count)
    update_column(:number_of_subjects, count)
  end

  def status_changes_log
    (status_changes || []).reverse.map do |change|
      {
        'from' => change['from'] || change[:from],
        'to' => change['to'] || change[:to],
        'changed_at' => change['changed_at'] || change[:changed_at],
        'changed_by' => change['changed_by'] || change[:changed_by]
      }
    end
  end

  private

  def log_status_change
    old_status = status_was || 'No Status'
    new_status = status || 'No Status'

    return if old_status == new_status

    changes = status_changes || []
    changes << {
      'from' => old_status,
      'to' => new_status,
      'changed_at' => Time.current.iso8601,
      'changed_by' => changed_by_user_email || 'System'
    }

    self.status_changes = changes
  end
end
