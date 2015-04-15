require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :body }
  it { should accept_nested_attributes_for(:attachments) }


  describe 'Accept answer' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }

    it 'marks answer as Accepted' do
      expect(answer.accept).to_not eq answer
      expect(answer.accepted).to eq true
    end

    it 'does not change Accepted answer to Unaccepted' do
      answer.accept
      answer.accept
      expect(answer.accepted).to eq true
    end

    it 'makes only one Accepted answer per question' do
      answer_2 = create(:answer, user: user, question: question)

      answer.accept
      answer_2.accept

      answer.reload
      answer_2.reload

      expect(answer.accepted).to eq false
      expect(answer_2.accepted).to eq true
    end
  end
end
