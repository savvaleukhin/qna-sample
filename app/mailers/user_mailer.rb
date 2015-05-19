  class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.notify_question_owner.subject
  #
  def notify_question_owner(answer_id)
    @answer = Answer.find(answer_id)
    recipient = @answer.question.user.email

    mail(to: recipient, subject: 'New answer for your question')
  end
end
