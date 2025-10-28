class LearnerInfo < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :hub, optional: true
  has_many :learner_documents, dependent: :destroy
  has_many :learner_info_logs, dependent: :delete_all
  has_one :learner_finance, dependent: :destroy

  accepts_nested_attributes_for :learner_finance, update_only: true

  EMAIL_FIELDS = %w[
    personal_email
    institutional_email
    parent1_email
    parent2_email
    previous_school_email
  ].freeze

  # Curriculum mapping constants
  CURRICULUM_MAP = {
    'american curriculum (fia)' => 'American Curriculum',
    'british curriculum' => 'British Curriculum',
    'alternative (own) curriculum' => 'Own Curriculum',
    'up business' => 'UP Business',
    'american curriculum (ecampus)' => 'Own Curriculum',
    'up sports and leisure' => 'UP Sports Management',
    'unsure' => nil,
    'up computing' => 'UP Computing',
    'american curriculum (flvs)' => 'Own Curriculum',
    'up business (bga)' => 'UP Business',
    'esl course' => 'ESL Course',
    'portuguese curriculum' => 'Portuguese Curriculum',
    'american curriculum' => 'American Curriculum',
    'up business management' => 'UPx Business',
    'own curriculum' => 'Own Curriculum',
    'upx business management' => 'UPx Business',
    'up business ; upx business management' => 'UPx Business'
  }.freeze

  GRADES_PER_CURRICULUM = {
    "British Curriculum" => ["UK Year 13", "UK Year 12", "UK Year 11", "UK Year 10", "UK Year 9", "UK Year 8"],
    "American Curriculum" => ["US Year 12", "US Year 11", "US Year 10", "US Year 9", "US Year 8", "US Year 7", "US Year 6", "US Year 5"],
    "Portuguese Curriculum" => ["PT Year 12", "PT Year 11", "PT Year 10", "PT Year 9", "PT Year 8", "PT Year 7"],
    "Own Curriculum" => ["N/A"],
    "ESL Course" => ["N/A"],
    "UP Business" => ["Level 3", "Level 4", "Level 5", "Level 6"],
    "UPx Business" => ["Level 3", "Level 4", "Level 5", "Level 6"],
    "UP Sports Management" => ["Level 3", "Level 4", "Level 5", "Level 6"],
    "UP Sports Exercise" => ["Level 3", "Level 4", "Level 5", "Level 6"],
    "UP Computing" => ["Level 3", "Level 4", "Level 5", "Level 6"]
  }.freeze

  # Grade conversion mappings
  US_TO_UK_GRADE_MAP = {
    12 => 13, 11 => 12, 10 => 11, 9 => 10, 8 => 9, 7 => 8
  }.freeze

  UK_TO_US_GRADE_MAP = {
    13 => 12, 12 => 11, 11 => 10, 10 => 9, 9 => 8, 8 => 7
  }.freeze

  US_TO_PT_GRADE_MAP = US_TO_UK_GRADE_MAP # PT follows similar pattern to UK

  US_TO_LEVEL_MAP = {
    12 => 6, 11 => 5, 10 => 4, 9 => 3
  }.freeze

  before_validation :normalize_emails
  before_validation :normalize_curriculum
  before_validation :normalize_grade
  before_save :update_status_based_on_notes

  VALID_EMAIL_REGEX = URI::MailTo::EMAIL_REGEXP

  validates *EMAIL_FIELDS.map(&:to_sym),
            format: { with: VALID_EMAIL_REGEX, message: "is not a valid email" },
            allow_blank: true

  # Class methods for normalization (can be used independently)
  class << self
    def normalize_curriculum_value(raw_curriculum)
      return nil if raw_curriculum.nil? || raw_curriculum.to_s.strip.empty?

      normalized_key = raw_curriculum.to_s.strip.downcase
      mapped = CURRICULUM_MAP[normalized_key]

      return mapped if mapped || CURRICULUM_MAP.key?(normalized_key)

      # Fallback patterns
      if normalized_key.include?('upx') && normalized_key.include?('business')
        return 'UPx Business'
      elsif normalized_key.include?('up') && normalized_key.include?('business')
        return 'UP Business'
      elsif normalized_key.include?('ecampus') || normalized_key.include?('flvs')
        return 'Own Curriculum'
      end

      # Return original if no mapping found
      raw_curriculum.to_s.strip
    end

    def normalize_grade_value(raw_grade, curriculum)
      return nil if raw_grade.nil? || raw_grade.to_s.strip.empty?
      return nil if curriculum.nil?

      grade_str = raw_grade.to_s.strip

      # Extract year/grade numbers from various formats
      us_match = grade_str.match(/US\s+(?:Grade|Year)\s+(\d+)/i)
      uk_match = grade_str.match(/UK\s+Year\s+(\d+)/i)
      pt_match = grade_str.match(/PT\s+Year\s+(\d+)/i)
      level_match = grade_str.match(/Level\s+(\d+)/i)
      simple_number = grade_str.match(/^\d+$/) ? grade_str.to_i : nil

      case curriculum
      when 'British Curriculum'
        if uk_match
          "UK Year #{uk_match[1].to_i}"
        elsif us_match
          us_grade = us_match[1].to_i
          uk_year = US_TO_UK_GRADE_MAP[us_grade] || us_grade
          "UK Year #{uk_year}"
        elsif simple_number
          "UK Year #{simple_number}"
        else
          raw_grade
        end

      when 'American Curriculum'
        if us_match
          "US Year #{us_match[1].to_i}"
        elsif uk_match
          uk_year = uk_match[1].to_i
          us_grade = UK_TO_US_GRADE_MAP[uk_year] || uk_year
          "US Year #{us_grade}"
        elsif simple_number
          "US Year #{simple_number}"
        else
          raw_grade
        end

      when 'Portuguese Curriculum'
        if pt_match
          "PT Year #{pt_match[1].to_i}"
        elsif us_match
          us_grade = us_match[1].to_i
          pt_year = US_TO_PT_GRADE_MAP[us_grade] || us_grade
          "PT Year #{pt_year}"
        elsif simple_number
          "PT Year #{simple_number}"
        else
          raw_grade
        end

      when 'UP Business', 'UPx Business', 'UP Computing', 'UP Sports Management', 'UP Sports Exercise'
        if level_match
          "Level #{level_match[1].to_i}"
        elsif us_match
          us_grade = us_match[1].to_i
          level = US_TO_LEVEL_MAP[us_grade]
          level ? "Level #{level}" : raw_grade
        elsif simple_number && simple_number >= 3 && simple_number <= 6
          "Level #{simple_number}"
        else
          raw_grade
        end

      when 'Own Curriculum', 'ESL Course'
        nil

      else
        raw_grade
      end
    end

    # Calculate grade from HubSpot format (e.g., "Year 11 (grade 10) - IGCSEs")
    def calculate_grade_from_hubspot(raw_grade_string, curriculum)
      return nil if curriculum.nil? || raw_grade_string.nil? || raw_grade_string.strip.empty?

      # Clean the grade string: "Year 11 (grade 10) - IGCSEs" -> "Year 11 (grade 10)"
      cleaned_grade_string = raw_grade_string.split(' - ').first.to_s.strip

      # Extract the year number (e.g., "Year 11 (grade 10)" -> 11)
      match = cleaned_grade_string.match(/Year\s*(\d+)/i)
      base_year = match ? match[1].to_i : nil

      return nil if base_year.nil?

      # UP courses, Own, and ESL use first level/value
      if curriculum.include?("UP") || ["Own Curriculum", "ESL Course"].include?(curriculum)
        return GRADES_PER_CURRICULUM[curriculum]&.first
      end

      # Calculate final year based on curriculum
      final_year = base_year
      prefix = ''

      case curriculum
      when "British Curriculum"
        prefix = 'UK Year '
      when "American Curriculum"
        final_year -= 1 unless final_year.zero?
        prefix = 'US Year '
      when "Portuguese Curriculum"
        final_year -= 1 unless final_year.zero?
        prefix = 'PT Year '
      else
        Rails.logger.warn("Unhandled curriculum in HubSpot calculation: #{curriculum}")
        prefix = 'Unknown Year '
      end

      "#{prefix}#{final_year}"
    end
  end

  def log_update(by_user = nil, saved_changes_hash = nil, note: nil)
    saved_changes_hash ||= saved_changes
    return if saved_changes_hash.blank?

    ignore_keys = %w[updated_at]
    changes = saved_changes_hash.except(*ignore_keys)

    return if changes.blank?

    changed_fields = changes.keys.map(&:to_s)
    changed_data = changes.transform_values { |v| { 'from' => v[0], 'to' => v[1] } }

    learner_info_logs.create!(
      user: by_user,
      action: 'update',
      changed_fields: changed_fields,
      changed_data: changed_data,
      note: note
    )
  end

  def institutional_email_prefix
    institutional_email.to_s.split('@').first || ''
  end

  def institutional_email_prefix=(prefix)
    self.institutional_email = prefix.present? ? "#{prefix.strip.downcase}@edubga.com" : nil
  end

  private

  def normalize_emails
    EMAIL_FIELDS.each do |attr|
      next unless (val = self[attr]).present?
      self[attr] = val.strip.downcase
    end
  end

  def normalize_curriculum
    return unless curriculum_course_option_changed? && curriculum_course_option.present?

    old_value = curriculum_course_option
    normalized = self.class.normalize_curriculum_value(old_value)

    if normalized != old_value
      self.curriculum_course_option = normalized
      Rails.logger.info("Normalized curriculum: #{old_value.inspect} -> #{normalized.inspect}")
    end
  end

  def normalize_grade
    return unless (grade_year_changed? || curriculum_course_option_changed?) &&
                  grade_year.present? && curriculum_course_option.present?

    old_value = grade_year
    normalized = self.class.normalize_grade_value(old_value, curriculum_course_option)

    if normalized != old_value
      self.grade_year = normalized
      Rails.logger.info("Normalized grade: #{old_value.inspect} -> #{normalized.inspect} (curriculum: #{curriculum_course_option})")
    end
  end

  def update_status_based_on_notes
    if onboarding_meeting_notes_changed?
      if onboarding_meeting_notes_was.blank? && onboarding_meeting_notes.present?
        case status
        when "Waitlist"
          self.status = "Waitlist - ok"
        when "In progress"
          self.status = "In progress - ok"
        end
      elsif onboarding_meeting_notes_was.present? && onboarding_meeting_notes.blank?
        case status
        when "Waitlist - ok"
          self.status = "Waitlist"
        when "In progress - ok"
          self.status = "In progress"
        end
      end
    end
  end
end
