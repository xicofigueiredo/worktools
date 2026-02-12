class Interrogation < ApplicationRecord
  has_many :form_interrogation_joins
  has_many :forms, through: :form_interrogation_joins

  scope :active, -> { where(active: true) }

  # Question types
  QUESTION_TYPES = {
    text: 'text',
    textarea: 'textarea',
    yes_no: 'yes_no',
    dropdown: 'dropdown',
    radio: 'radio'
  }.freeze

  # Parse options JSON string to array
  def options_array
    return [] if options.blank?
    JSON.parse(options) rescue []
  end

  # Check if question type supports options
  def requires_options?
    %w[dropdown radio].include?(question_type)
  end

  # Check if question type is yes/no
  def yes_no?
    question_type == QUESTION_TYPES[:yes_no]
  end

  # Check if question type is dropdown
  def dropdown?
    question_type == QUESTION_TYPES[:dropdown]
  end

  # Check if question type is text
  def text?
    question_type == QUESTION_TYPES[:text] || question_type.blank?
  end

  # Check if question type is textarea
  def textarea?
    question_type == QUESTION_TYPES[:textarea]
  end
end
