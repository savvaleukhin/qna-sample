require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should validate_presence_of :subscriber_id }
  it { should validate_presence_of :tracking_question_id }
  it { should belong_to :subscriber }
  it { should belong_to :tracking_question }

  it 'has uniqueness of tracking_question_id' do
    user = create(:user)
    question = create(:question, user: user)
    create(:subscription, subscriber_id: user.id, tracking_question_id: question.id)

    should validate_uniqueness_of(:subscriber_id).scoped_to(:tracking_question_id)
  end
end
