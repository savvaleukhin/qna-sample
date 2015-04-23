require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:non_author) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { sign_in_user(user) }

    context 'JSON with valid attributes' do
      let(:post_answer) do
        post(
          :create,
          question_id: question,
          answer: attributes_for(:answer),
          format: :json)
      end

      it 'saves the new answer in the database' do
        expect { post_answer }.to change(Answer, :count).by(1)
      end

      it 'associates the new answer with the question' do
        expect { post_answer }.to change(question.answers, :count).by(1)
      end

      it 'response' do
        post_answer
        expect(response.status).to eq 200
      end
    end

    context 'JSON with invalid attributes' do
      let(:post_invalid_answer) do
        post(
          :create,
          question_id: question,
          answer: attributes_for(:invalid_answer),
          format: :json)
      end

      it 'does not save new answer in the database' do
        expect { post_invalid_answer }.to_not change(Answer, :count)
      end

      it 'unprocessable entity' do
        post_invalid_answer
        expect(response.status).to eq 422
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in_user(answer.user) }

    context 'JSON valid attributes' do
      let(:update_answer) do
        patch(
          :update,
          question_id: answer.question,
          id: answer,
          answer: { body: 'New body of answer' },
          format: :json)
      end

      it 'changes answer attributes' do
        update_answer
        answer.reload
        expect(answer.body).to eq 'New body of answer'
      end

      it 'response' do
        update_answer
        expect(response.status).to eq 200
      end
    end

    context 'JSON invalid attributes' do
      it 'does not change the answer in the database' do
        patch(
          :update,
          question_id: answer.question,
          id: answer,
          answer: { body: nil },
          format: :json)

        answer.reload
        expect(answer.body).to eq 'MyText'
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_answer) do
      delete(
        :destroy,
        question_id: answer.question,
        id: answer,
        format: :js)
    end

    context 'valid user' do
      before { sign_in_user(answer.user) }

      it 'deletes the answer' do
        expect { delete_answer }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy tempate' do
        delete_answer
        expect(response).to render_template :destroy
      end
    end

    context 'invalid user' do
      before { sign_in_user(non_author) }

      it 'can not to delete the answer' do
        answer
        expect { delete_answer }.not_to change(Answer, :count)
      end

      it 'redirects to root path' do
        delete_answer
        expect(response).to redirect_to root_path
      end
    end

    context 'guest user' do
      it 'can not to delete the answer' do
        answer
        expect do
          delete(
            :destroy,
            question_id: answer.question,
            id: answer)
        end.not_to change(Answer, :count)
      end

      it 'redirects to sign in page' do
        delete :destroy, question_id: answer.question, id: answer
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #accept' do
    let(:accept_answer) do
      post :accept, question_id: answer.question, id: answer, format: :js
    end

    context 'valid user' do
      before { sign_in_user(answer.user) }

      it 'marks the answer as Accepted' do
        expect { accept_answer }.to change { answer.reload.accepted }.from(false).to(true)
      end

      it 'renders accept template' do
        accept_answer
        expect(response).to render_template :accept
      end
    end

    context 'invalid user' do
      before { sign_in_user(non_author) }

      it 'can not mark the answer as Accepted' do
        expect { accept_answer }.not_to change { answer.reload.accepted }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'guest user' do
      it 'can not mark the answer as Accepted' do
        expect { accept_answer }.not_to change { answer.reload.accepted }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #vote' do
    let(:vote_up_for_answer) do
      post :vote, question_id: answer.question, id: answer, value: 1, format: :js
    end

    let(:vote_down_for_answer) do
      post :vote, question_id: answer.question, id: answer, value: -1, format: :js
    end

    context 'valid user' do
      before { sign_in_user(non_author) }

      it 'votes UP for the answer' do
        expect { vote_up_for_answer }.to change(Vote, :count).by(1)
      end

      it 'votes DOWN for the answer' do
        expect { vote_down_for_answer }.to change(Vote, :count).by(1)
      end
    end

    context 'invalid user' do
      before { sign_in_user(answer.user) }

      it 'can not vote for the answer' do
        expect { vote_up_for_answer }.not_to change(Vote, :count)
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'guest user' do
      it 'can not vote for the answer' do
        expect { vote_up_for_answer }.not_to change(Vote, :count)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #unvote' do
    let(:unvote_for_answer) do
      post :unvote, question_id: answer.question, id: answer, format: :js
    end

    before do
      create(
        :vote,
        user_id: non_author.id,
        votable_id: answer.id,
        votable_type: answer.class.name)
    end

    context 'valid user' do
      before { sign_in_user(non_author) }

      it 'unvotes' do
        expect { unvote_for_answer }.to change(Vote, :count).by(-1)
      end
    end

    context 'invalid user' do
      before { sign_in_user(answer.user) }

      it 'can not unvote' do
        expect { unvote_for_answer }.not_to change(Vote, :count)
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'guest user' do
      it 'can not unvote' do
        expect { unvote_for_answer }.not_to change(Vote, :count)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
