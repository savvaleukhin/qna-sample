require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:answer) { create(:answer, user: author, question: question) }

  describe 'POST #create' do
    context 'Comment a Question' do
      context 'Valid attributes' do
        before { sign_in_user(user) }

        let(:post_comment) do
          post :create,
            commentable: 'questions',
            question_id: question,
            comment: attributes_for(:comment),
            format: :json
        end

        it 'saves a new comment in the database' do
          expect { post_comment }.to change(Comment, :count).by(1)
        end

        it 'associates the new comment with the question' do
          expect { post_comment }.to change(question.comments, :count).by(1)
        end

        it 'response' do
          post_comment
          expect(response.status).to eq 200
        end
      end

      context 'Invalid attributes' do
        before { sign_in_user(user) }

        let(:post_comment) do
          post :create,
            commentable: 'questions',
            question_id: question,
            comment: attributes_for(:invalid_comment),
            format: :json
        end

        it 'does not save a new comment in the database' do
          expect { post_comment }.to_not change(Comment, :count)
        end

        it 'unprocessable entity' do
          post_comment
          expect(response.status).to eq 422
        end
      end

      context 'Non authenticated user' do
        it 'does not save a new comment in the database' do
          expect do
            post :create,
              commentable: 'questions',
              question_id: question,
              comment: attributes_for(:comment),
              format: :json
          end.to_not change(Comment, :count)
        end
      end
    end

    context 'Comment an Answer' do
      context 'Valid attributes' do
        before { sign_in_user(user) }

        let(:post_comment) do
          post :create,
            commentable: 'answers',
            answer_id: answer,
            comment: attributes_for(:comment),
            format: :json
        end

        it 'saves a new comment in the database' do
          expect { post_comment }.to change(Comment, :count).by(1)
        end

        it 'associates the new comment with the answer' do
          expect { post_comment }.to change(answer.comments, :count).by(1)
        end

        it 'response' do
          post_comment
          expect(response.status).to eq 200
        end
      end

      context 'Invalid attributes' do
        before { sign_in_user(user) }

        let(:post_comment) do
          post :create,
            commentable: 'answers',
            answer_id: answer,
            comment: attributes_for(:invalid_comment),
            format: :json
        end

        it 'does not save a new comment in the database' do
          expect { post_comment }.to_not change(Comment, :count)
        end

        it 'unprocessable entity' do
          post_comment
          expect(response.status).to eq 422
        end
      end

      context 'Non authenticated user' do
        it 'does not save a new comment in the database' do
          expect do
            post :create,
              commentable: 'answers',
              answer_id: answer,
              comment: attributes_for(:comment),
              format: :json
          end.to_not change(Comment, :count)
        end
      end
    end
  end
end
