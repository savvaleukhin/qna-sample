require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:answer) { create(:answer, user: author, question: question) }

  describe 'POST #create' do
    context 'Comment for Question' do
      let(:commentable) { create(:question_with_user) }

      it_behaves_like 'comment that can be created'

      def post_comment_for(options = {})
        post(
          :create,
          { commentable: 'questions', question_id: commentable, format: :json }.merge(options)
        )
      end
    end

    context 'Comment for Answer' do
      let(:commentable) { create(:answer_with_user) }

      it_behaves_like 'comment that can be created'

      def post_comment_for(options = {})
        post(
          :create,
          { commentable: 'answers', answer_id: commentable, format: :json }.merge(options)
        )
      end
    end
  end

  describe 'PATCH #update' do
    context 'Comment for Question' do
      let(:comment) { create(:comment, commentable: question, user: author) }

      it_behaves_like 'comment that can be updated'

      def update_comment_for(options = {})
        patch(
          :update,
          { question_id: comment.commentable,
            commentable: 'questions',
            id: comment,
            format: :json }.merge(options))
      end
    end

    context 'Comment for Answer' do
      let(:comment) { create(:comment, commentable: answer, user: author) }

      it_behaves_like 'comment that can be updated'

      def update_comment_for(options = {})
        patch(
          :update,
          { answer_id: comment.commentable,
            commentable: 'answers',
            id: comment,
            format: :json }.merge(options))
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Comment for Question' do
      let(:comment) { create(:comment, commentable: answer, user: author) }
      let(:delete_comment) do
        delete(
          :destroy,
          answer_id: comment.commentable,
          commentable: 'answers',
          id: comment,
          format: :json)
      end

      it_behaves_like 'comment that can be destroyed'
    end

    context 'Comment for Answer' do
      let(:comment) { create(:comment, commentable: question, user: author) }
      let(:delete_comment) do
        delete(
          :destroy,
          question_id: comment.commentable,
          commentable: 'questions',
          id: comment,
          format: :json)
      end

      it_behaves_like 'comment that can be destroyed'
    end
  end
end
