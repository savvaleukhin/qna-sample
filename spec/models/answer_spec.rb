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
      it 'runs Calculate Reputation Job after creating' do
        expect(UpdateReputationJob).to(
          receive(:perform_later).with(subject, 'create', subject.user_id))
        subject.save!
      end

      it 'does not run Calculate Reputation Job after updating' do
        subject.save!
        expect(UpdateReputationJob).to_not receive(:perform_later)
        subject.update(body: 'new body')
      end
    end

    context 'after accepting answer' do
      before { subject.save! }

      it 'runs Calculate Reputation Job' do
        expect(UpdateReputationJob).to(
          receive(:perform_later).with(subject, 'accept', subject.user_id))
        subject.accept
      end
    end

    context 'before destroying answer' do
      before { subject.save! }

      it 'runs Calculate Reputation Job' do
        expect(UpdateReputationJob).to(
          receive(:perform_later).with(subject, 'destroy', subject.user_id))
        subject.destroy
      end
    end
  end

  describe '#notify_question_owner' do
    subject { build(:answer_with_user) }

    it 'sends notification to question owner' do
      expect(UserMailer).to(
        receive(:new_answer_notification).with(
          subject.question.user.email, subject).and_call_original)
      subject.save!
    end
  end

  describe '#notify_question_subscribers' do
    subject { build(:answer_with_user) }

    it 'sends notifications to question subscribers' do
      expect(NotifySubscribersJob).to receive(:perform_later)
      subject.save!
    end
  end
end
