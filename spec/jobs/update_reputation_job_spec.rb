require 'rails_helper'

RSpec.describe UpdateReputationJob, type: :job do
  let!(:answer) { create(:answer_with_user) }
  let(:user) { answer.user }

  context 'Answer' do
    context '#create' do
      it 'calculates reputation' do
        allow(Reputation).to receive(:calculate).and_return(2)
        expect(Reputation).to receive(:calculate).with(answer, 'create')
        subject.perform(answer, 'create', user.id)
      end

      it 'updates user reputation' do
        user.reload
        allow(Reputation).to receive(:calculate).and_return(2)
        expect do
          subject.perform(answer, 'create', user.id)
          user.reload
        end.to change(user, :reputation).by(2)
      end
    end

    context '#accept' do
      it 'calculates reputation' do
        allow(Reputation).to receive(:calculate).and_return(3)
        expect(Reputation).to receive(:calculate).with(answer, 'accept')
        subject.perform(answer, 'accept', user.id)
      end

      it 'updates user reputation' do
        user.reload
        allow(Reputation).to receive(:calculate).and_return(3)
        expect do
          subject.perform(answer, 'accept', user.id)
          user.reload
        end.to change(user, :reputation).by(3)
      end
    end

    context '#destroy' do
      it 'calculates reputation' do
        allow(Reputation).to receive(:calculate).and_return(3)
        expect(Reputation).to receive(:calculate).with(answer, 'destroy')
        subject.perform(answer, 'destroy', user.id)
      end

      it 'updates user reputation' do
        user.reload
        allow(Reputation).to receive(:calculate).and_return(-3)
        expect do
          subject.perform(answer, 'destroy', user.id)
          user.reload
        end.to change(user, :reputation).by(-3)
      end
    end
  end

  context 'Vote' do
    context 'vote_up' do
      it 'calculates reputation' do
        allow(Reputation).to receive(:calculate).and_return(1)
        expect(Reputation).to receive(:calculate).with(answer, 'vote_up')
        subject.perform(answer, 'vote_up', user.id)
      end

      it 'updates user reputation' do
        user.reload
        allow(Reputation).to receive(:calculate).and_return(1)
        expect do
          subject.perform(answer, 'vote_up', user.id)
          user.reload
        end.to change(user, :reputation).by(1)
      end
    end

    context 'vote_down' do
      it 'calculates reputation' do
        allow(Reputation).to receive(:calculate).and_return(-1)
        expect(Reputation).to receive(:calculate).with(answer, 'vote_down')
        subject.perform(answer, 'vote_down', user.id)
      end

      it 'updates user reputation' do
        user.reload
        allow(Reputation).to receive(:calculate).and_return(-1)
        expect do
          subject.perform(answer, 'vote_down', user.id)
          user.reload
        end.to change(user, :reputation).by(-1)
      end
    end
  end
end
