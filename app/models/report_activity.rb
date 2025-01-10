class ReportActivity < ApplicationRecord
  belongs_to :report
  belongs_to :skill, optional: true
  belongs_to :community, optional: true
end
