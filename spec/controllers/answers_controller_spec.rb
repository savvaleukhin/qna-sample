require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:wrong_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { sign_in_user(user) }

    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(Answer, :count).by(1)
      end

      it 'associates the new answer with the question' do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end

      it 're-renders create view' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save new answer in the database' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end

      it 're-renders create view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in_user(answer.user) }

    context 'valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, question_id: answer.question, id: answer, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'assigns the question for requested answer to @question' do
        patch :update, question_id: answer.question, id: answer, answer: attributes_for(:answer), format: :js
        expect(assigns(:question)).to eq answer.question
      end

      it 'changes answer attributes' do
        patch :update, question_id: answer.question, id: answer, answer: { body: "New body of answer" }, format: :js
        answer.reload
        expect(answer.body).to eq "New body of answer"
      end

      it 'renders update tempate' do
        patch :update, question_id: answer.question, id: answer, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do
      it 'does not change the answer in the database' do
        patch :update, question_id: answer.question, id: answer, answer: { body: nil }, format: :js
        answer.reload
        expect(answer.body).to eq 'MyText'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'valid user' do
      before { sign_in_user(answer.user) }

      it 'deletes the answer' do
        expect { delete :destroy, question_id: answer.question, id: answer }.to change(Answer, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, question_id: answer.question, id: answer
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'invalid user' do
      before { sign_in_user(wrong_user) }

      it 'can not to delete the answer' do
        answer
        expect { delete :destroy, question_id: answer.question, id: answer }.not_to change(Answer, :count)
      end

      it 'redirects to root path' do
        delete :destroy, question_id: answer.question, id: answer
        expect(response).to redirect_to root_path
      end
    end

    context 'guest user' do
      it 'can not to delete the answer' do
        answer
        expect { delete :destroy, question_id: answer.question, id: answer }.not_to change(Answer, :count)
      end

      it 'redirects to sign in page' do
        delete :destroy, question_id: answer.question, id: answer
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
