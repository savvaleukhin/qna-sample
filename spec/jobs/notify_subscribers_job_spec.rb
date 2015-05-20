require 'rails_helper'

RSpec.describe NotifySubscribersJob, type: :job do
  let(:users) { create_list(:user, 2) }
  let(:question) { create(:question, user: users.first) }
  let(:answer) { create(:answer, question: question, user: users.first) }
  let!(:subscription_1) do
    create(:subscription, subscriber: users.first, tracking_question: question)
  end

  let!(:subscription_2) do
    create(:subscription, subscriber: users[1], tracking_question: question)
  end

  it 'sends notification to question subscribers' do
    users.each do |user|
      expect(UserMailer).to(
        receive(:new_answer_notification).with(user.email, answer).and_call_original)
    end
    subject.perform(answer)
  end
end
