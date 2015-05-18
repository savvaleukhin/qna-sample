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

  it_behaves_like 'votable' do
    let(:votable) { create(:answer_with_user) }
  end

  describe 'reputation' do
    subject { build(:answer_with_user) }

    context 'after saving answer' do
      it 'calculates reputation after creating' do
        allow(Reputation).to receive(:calculate).and_return(2)
        expect(Reputation).to receive(:calculate).with(subject, :create)
        subject.save!
      end

      it 'does not calculate reputation after updating' do
        subject.save!
        expect(Reputation).to_not receive(:calculate)
        subject.update(body: 'new body')
      end

      it 'saves user reputation' do
        allow(Reputation).to receive(:calculate).and_return(2)
        expect { subject.save! }.to change(subject.user, :reputation).by(2)
      end
    end

    context 'after accepting answer' do
      before { subject.save! }

      it 'calculates reputation' do
        allow(Reputation).to receive(:calculate).and_return(3)
        expect(Reputation).to receive(:calculate).with(subject, :accept)
        subject.accept
      end

      it 'saves user reputation' do
        allow(Reputation).to receive(:calculate).and_return(3)
        expect { subject.accept }.to change(subject.user, :reputation).by(3)
      end
    end
  end
end
