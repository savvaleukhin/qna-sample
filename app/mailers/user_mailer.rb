  class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.notify_question_owner.subject
  #
  def new_answer_notification(email, answer)
    @answer = answer
    mail(to: email, subject: 'New answer')
  end
end
