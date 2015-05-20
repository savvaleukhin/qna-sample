class NotifySubscribersJob < ActiveJob::Base
  queue_as :default

  def perform(answer)
    answer.question.subscribers.each do |user|
      UserMailer.new_answer_notification(user.email, answer).deliver_later
    end
  end
end
