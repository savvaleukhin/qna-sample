class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :user_id, :body, presence: true
  scope :by_top, -> { order('accepted DESC') }

  def accept
    accepted_answers =  Question.find(self.question_id).answers.where(accepted: true)

    if accepted_answers.count > 0
      accepted_answers.each do |answer|
        answer.update(accepted: false) unless answer == self
      end
    end
    self.update(accepted: true)
  end
end