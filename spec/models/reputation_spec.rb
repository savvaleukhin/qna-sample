require 'rails_helper'

describe Reputation do
  describe 'Answer actions' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:question) { create(:question, user: user) }

    context 'Create' do
      context 'the first answer' do
        context 'user is the question author' do
          let(:answer) { create(:answer, question: question, user: user) }

          it 'returns +4 after creating answer' do
            expect(Reputation.calculate(answer, :create)).to eq 4
          end
        end

        context 'user is not the question author' do
          let(:answer) { create(:answer, question: question, user: other) }

          it 'returns +2 after creating answer' do
            expect(Reputation.calculate(answer, :create)).to eq 2
          end
        end
      end

      context 'not the first answer' do
        let!(:first_answer) { create(:answer, question: question, user: user) }

        context 'user is the question author' do
          let(:answer) { create(:answer, question: question, user: user) }

          it 'returns +3 after creating answer' do
            expect(Reputation.calculate(answer, :create)).to eq 3
          end
        end

        context 'user is not the question author' do
          let(:answer) { create(:answer, question: question, user: other) }

          it 'returns +1 after creating answer' do
            expect(Reputation.calculate(answer, :create)).to eq 1
          end
        end
      end
    end

    context 'Accept' do
      let(:answer) { create(:answer, question: question, user: other) }

      it 'returns +3' do
        expect(Reputation.calculate(answer, :accept)).to eq 3
      end
    end

    context 'Vote' do
      let(:answer) { create(:answer, question: question, user: other) }

      context 'up' do
        it 'returns +1' do
          expect(Reputation.calculate(answer, :vote_up)).to eq 1
        end
      end

      context 'down' do
        it 'returns -1' do
          expect(Reputation.calculate(answer, :vote_down)).to eq(-1)
        end
      end
    end
  end

  describe 'Question actions' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    context 'Vote' do
      context 'up' do
        it 'returns +2' do
          expect(Reputation.calculate(question, :vote_up)).to eq 2
        end
      end

      context 'down' do
        it 'returns -2' do
          expect(Reputation.calculate(question, :vote_down)).to eq(-2)
        end
      end
    end
  end
end
