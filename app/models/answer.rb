class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :user_id, :body, presence: true
  scope :by_top, -> { order('accepted DESC') }

  def accept
    Answer.transaction do
      Answer.where(question_id: question_id, accepted: true).update_all(accepted: false)
      update(accepted: true)
    end
  end
end