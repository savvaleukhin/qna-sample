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
          post(
            :create,
            commentable: 'questions',
            question_id: question,
            comment: attributes_for(:comment),
            format: :json)
        end

        it 'saves a new comment in the database' do
          expect { post_comment }.to change(Comment, :count).by(1)
        end

        it 'associates the new comment with the question' do
          expect { post_comment }.to change(question.comments, :count).by(1)
        end

        it 'response' do
          post_comment
          expect(response.status).to eq 204
        end
      end

      context 'Invalid attributes' do
        before { sign_in_user(user) }

        let(:post_comment) do
          post(
            :create,
            commentable: 'questions',
            question_id: question,
            comment: attributes_for(:invalid_comment),
            format: :json)
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
            post(
              :create,
              commentable: 'questions',
              question_id: question,
              comment: attributes_for(:comment),
              format: :json)
          end.to_not change(Comment, :count)
        end
      end
    end

    context 'Comment an Answer' do
      context 'Valid attributes' do
        before { sign_in_user(user) }

        let(:post_comment) do
          post(
            :create,
            commentable: 'answers',
            answer_id: answer,
            comment: attributes_for(:comment),
            format: :json)
        end

        it 'saves a new comment in the database' do
          expect { post_comment }.to change(Comment, :count).by(1)
        end

        it 'associates the new comment with the answer' do
          expect { post_comment }.to change(answer.comments, :count).by(1)
        end

        it 'response' do
          post_comment
          expect(response.status).to eq 204
        end
      end

      context 'Invalid attributes' do
        before { sign_in_user(user) }

        let(:post_comment) do
          post(
            :create,
            commentable: 'answers',
            answer_id: answer,
            comment: attributes_for(:invalid_comment),
            format: :json)
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
            post(
              :create,
              commentable: 'answers',
              answer_id: answer,
              comment: attributes_for(:comment),
              format: :json)
          end.to_not change(Comment, :count)
        end
      end
    end
  end

  describe 'PATCH #update' do
    let(:comment) { create(:comment, commentable: answer, user: author) }
    before { sign_in_user(comment.user) }

    context 'Valid attributes' do
      let(:update_comment) do
        patch(
          :update,
          answer_id: comment.commentable,
          commentable: 'answers',
          id: comment,
          comment: { body: 'New comment' },
          format: :json)
      end

      it 'changes comment attributes' do
        update_comment
        comment.reload
        expect(comment.body).to eq 'New comment'
      end

      it 'response' do
        update_comment
        expect(response.status).to eq 204
      end
    end

    context 'Invalid attributes' do
      it 'does not change the answer in the database' do
        patch(
          :update,
          answer_id: comment.commentable,
          commentable: 'answers',
          id: comment,
          comment: { body: nil },
          format: :json)

        comment.reload
        expect(comment.body).to eq 'My comment'
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:comment) { create(:comment, commentable: answer, user: author) }
    let(:delete_comment) do
      delete(
        :destroy,
        answer_id: comment.commentable,
        commentable: 'answers',
        id: comment,
        format: :json)
    end

    context 'valid user' do
      before { sign_in_user(comment.user) }

      it 'deletes the answer' do
        expect { delete_comment }.to change(Comment, :count).by(-1)
      end
    end

    context 'invalid user' do
      before { sign_in_user(user) }

      it 'can not to delete the answer' do
        comment
        expect { delete_comment }.not_to change(Answer, :count)
      end

      it 'redirects to root url' do
        delete_comment
        expect(response).to redirect_to root_url
      end
    end

    context 'guest user' do
      it 'can not to delete the answer' do
        comment
        expect do
          delete(
            :destroy,
            answer_id: comment.commentable,
            commentable: 'answers',
            id: comment,
            format: :json)
        end.not_to change(Answer, :count)
      end

      it 'redirects to sign in page' do
        delete :destroy, question_id: answer.question, id: answer
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
