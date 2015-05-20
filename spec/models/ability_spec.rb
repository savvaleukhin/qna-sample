require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'Guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }

    it { should_not be_able_to :manage, :all }
  end

  describe 'Admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'User' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:own_question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other) }
    let(:own_answer) { create(:answer_with_question, user: user) }
    let(:other_answer) { create(:answer_with_question, user: other) }
    let(:own_comment) { create(:comment_for_question, user: user) }
    let(:other_comment) { create(:comment_for_question, user: other) }
    let(:own_attachment) { create(:attachment, attachmentable: own_question) }
    let(:other_attachment) { create(:attachment, attachmentable: other_question) }
    let(:own_subscription) do
      create(:subscription, subscriber: user, tracking_question: other_question)
    end

    let(:other_subscription) do
      create(:subscription, subscriber: other, tracking_question: own_question)
    end

    it { should be_able_to :read, Question }
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, own_question, user: user }
    it { should_not be_able_to :update, other_question, user: user }

    it { should be_able_to :update, own_answer, user: user }
    it { should_not be_able_to :update, other_answer, user: user }

    it { should be_able_to :update, own_comment, user: user }
    it { should_not be_able_to :update, other_comment, user: user }

    it { should be_able_to :destroy, own_question, user: user }
    it { should_not be_able_to :destroy, other_question, user: user }

    it { should be_able_to :destroy, own_answer, user: user }
    it { should_not be_able_to :destroy, other_answer, user: user }

    it { should be_able_to :destroy, own_comment, user: user }
    it { should_not be_able_to :destroy, other_comment, user: user }

    it { should be_able_to :destroy, own_attachment, user: user }
    it { should_not be_able_to :destroy, other_attachment, user: user }

    it { should be_able_to :vote, other_question, user: user }
    it { should_not be_able_to :vote, own_question, user: user }

    it { should be_able_to :vote, other_answer, user: user }
    it { should_not be_able_to :vote, own_answer, user: user }

    it do
      should be_able_to :accept, create(:answer, user: other, question: own_question), user: user
    end

    it do
      should_not be_able_to(
        :accept,
        create(:answer, user: other, question: other_question),
        user: user
      )
    end

    it { should be_able_to :create, Subscription }
    it { should be_able_to :destroy, own_subscription, user: user }
    it { should_not be_able_to :destroy, other_subscription, user: user }
  end
end
