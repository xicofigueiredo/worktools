class ChatMessage < ApplicationRecord
  belongs_to :chat

  validates :role, presence: true, inclusion: { in: %w[user assistant system] }
  validates :content, presence: true

  scope :user_messages, -> { where(role: 'user') }
  scope :assistant_messages, -> { where(role: 'assistant') }
  scope :in_order, -> { order(:created_at) }

  def user_message?
    role == 'user'
  end

  def assistant_message?
    role == 'assistant'
  end

  def system_message?
    role == 'system'
  end
end
