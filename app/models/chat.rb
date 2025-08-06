class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :subject
  has_many :chat_messages, dependent: :destroy

  validates :system_prompt, presence: true

  scope :for_user_and_subject, ->(user, subject) { where(user: user, subject: subject) }

  def self.find_or_create_for_user_and_subject(user, subject)
    # Create a new chat session when subject changes
    system_prompt = generate_system_prompt(user, subject)

    create!(
      user: user,
      subject: subject,
      system_prompt: system_prompt
    )
  end

  def add_message(role, content)
    chat_messages.create!(role: role, content: content)
  end

  def conversation_history
    chat_messages.order(:created_at).pluck(:role, :content)
  end

  private

  def self.generate_system_prompt(user, subject)
    # Get user notes for context
    user_notes = user.notes.pluck(:topic, :category, :follow_up_action).map do |topic, category, action|
      "#{category}: #{topic}#{action.present? ? " (Action: #{action})" : ""}"
    end.join("; ")

    # Get progress on this subject from timelines
    subject_timeline = user.timelines.joins(:subject).where(subjects: { id: subject.id }).first
    progress_info = if subject_timeline
      "Progress: #{subject_timeline.progress}%, Expected: #{subject_timeline.expected_progress}%, Balance: #{subject_timeline.balance}"
    else
      "No timeline data available for this subject"
    end

    system_prompt = <<~PROMPT
      You are a tutor chatbot for #{user.full_name}.

      Student Information:
      - Level: #{user.level}
      - Nationality: #{user.nationality}
      - Native English Speaker: #{user.native_language_english? ? 'Yes' : 'No'}
      - Notes: #{user_notes.present? ? user_notes : 'No notes available'}

      Subject: #{subject.name}
      #{progress_info}

      Tailor your explanations to this learner's needs and focus on the selected subject.
      Be encouraging, clear, and adapt your language level appropriately.
      If the student is struggling (negative progress balance), offer additional support and break down concepts more simply.
    PROMPT

    system_prompt.strip
  end
end
