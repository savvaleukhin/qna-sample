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

  describe 'Vote for question' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'votes up' do
      vote = question.vote(user, 1)

      expect(vote.value).to eq 1
      expect(Vote.where(user_id: user, votable_id: question.id, votable_type: question.class.name).count).to eq 1
    end

    it 'votes down' do
      vote = question.vote(user, -1)

      expect(vote.value).to eq -1
      expect(Vote.where(user_id: user, votable_id: question.id, votable_type: question.class.name).count).to eq 1
    end

    it 'unvotes' do
      question.vote(user, 1)
      unvote = question.unvote(user)

      expect(Vote.where(user_id: user, votable_id: question.id, votable_type: question.class.name).count).to eq 0
    end
  end

  describe 'Vote for answer' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }

    it 'votes up' do
      vote = answer.vote(user, 1)

      expect(vote.value).to eq 1
      expect(Vote.where(user_id: user, votable_id: answer.id, votable_type: answer.class.name).count).to eq 1
    end

    it 'votes down' do
      vote = answer.vote(user, -1)

      expect(vote.value).to eq -1
      expect(Vote.where(user_id: user, votable_id: answer.id, votable_type: answer.class.name).count).to eq 1
    end

    it 'unvotes' do
      answer.vote(user, 1)
      unvote = answer.unvote(user)

      expect(Vote.where(user_id: user, votable_id: answer.id, votable_type: answer.class.name).count).to eq 0
    end
  end
end
