class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :user_id, :body, presence: true

  def accept
    question = Question.find(self.question_id)
    accepted_answers = question.answers.where(accepted: true)

    if accepted_answers.count > 0
      accepted_answers.each do |answer|
        answer.accepted = false
        answer.save
      end
    end
    self.accepted = true
    self.save
  end
end