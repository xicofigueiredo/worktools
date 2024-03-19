class Answer < ApplicationRecord
  has_many :questions_sprint_goals
  has_many :sprint_goals, through: :questions_sprint_goals
  belongs_to :kdas_question

  validates :questions_sprint_goal_id, presence: true

  def readable_answer_type(answer_type)
    case answer_type
    when 'sdl' then 'Self Directed Learning'
    when 'ini' then 'Initiative'
    when 'mot' then 'Motivation'
    when 'p2p' then 'Peer to Peer Learning'
    when 'hubp' then 'Hub Participation'
    else 'Unknown Type'
    end
  end
end
