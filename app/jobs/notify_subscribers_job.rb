class NotifySubscribersJob < ActiveJob::Base
  queue_as :default

  def perform(answer)
    answer.question.subscribers.each do |user|
      UserMailer.delay.new_answer_notification(user.email, answer)
    end
  end
end
