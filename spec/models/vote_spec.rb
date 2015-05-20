require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :votable_id }
  it { should validate_presence_of :votable_type }
  it { should validate_presence_of :value }
  it { should belong_to :user }
  it { should validate_inclusion_of(:value).in_array(%w(1 -1)) }

  it 'Uniqueness of vote' do
    user = create(:user)
    question = create(:question, user: user)
    create(:vote, user_id: user.id, votable_id: question.id, votable_type: question.class.name)

    should validate_uniqueness_of(:user_id).scoped_to([:votable_id, :votable_type])
  end

  describe 'reputation' do
    let(:question) { create(:question_with_user) }
    let(:user) { create(:user) }
    subject { build(:vote, value: 1, votable: question, user: user) }

    context 'after saving vote' do
      it 'does not run Calculate Reputation Job after updating' do
        subject.save!
        expect(UpdateReputationJob).to_not receive(:perform_later)
        subject.update(value: -1)
      end

      context 'upvote' do
        it 'runs Calculate Reputation Job after creating' do
          expect(UpdateReputationJob).to(
            receive(:perform_later).with(question, 'vote_up', question.user_id))
          subject.save!
        end
      end

      context 'downvote' do
        subject { build(:vote, value: -1, votable: question, user: user) }

        it 'runs Calculate Reputation Job after creating' do
          expect(UpdateReputationJob).to(
            receive(:perform_later).with(question, 'vote_down', question.user_id))
          subject.save!
        end
      end
    end

    context 'after destroying vote' do
      context 'destroying upvote' do
        subject { create(:vote, value: 1, votable: question, user: user) }

        it 'runs Calculate Reputation Job' do
          subject
          expect(UpdateReputationJob).to(
            receive(:perform_later).with(question, 'vote_down', question.user_id))
          subject.destroy
        end
      end

      context 'destroying downvote' do
        subject { create(:vote, value: -1, votable: question, user: user) }

        it 'runs Calculate Reputation Job' do
          subject
          expect(UpdateReputationJob).to(
            receive(:perform_later).with(question, 'vote_up', question.user_id))
          subject.destroy
        end
      end
    end
  end
end
