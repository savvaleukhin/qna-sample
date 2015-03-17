require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer_for_question) { create(:answer, question: question) }
  let(:answer_with_user) { create(:answer_with_user) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:answers) { create_list(:answer, 2, question: question) }

    before { get :index, question_id: question }

    it 'populate array of all answers related to the question' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, question_id: question, id: answer_for_question }

    it 'assigns the requested answer for specific question to @answer' do
      expect(assigns(:answer)).to eq answer_for_question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { sign_in_user(user) }
    before { get :new, question_id: question, id: answer_for_question }

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { sign_in_user(answer_with_user.user) }
    before { get :edit, question_id: answer_with_user.question, id: answer_with_user }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer_with_user
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { sign_in_user(user) }

    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(Answer, :count).by(1)
      end

      it 'associates the new answer with the question' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end      

      it 'rederects to show view' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_answer_path(question, assigns(:answer))
      end
    end

    context 'with invalid attributes' do
      it 'does not save new answer in the database' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in_user(answer_with_user.user) }

    context 'valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, question_id: answer_with_user.question, id: answer_with_user, answer: attributes_for(:answer)
        expect(assigns(:answer)).to eq answer_with_user
      end

      it 'changes answer attributes' do
        patch :update, question_id: answer_with_user.question, id: answer_with_user, answer: { body: "New body of answer" }
        answer_with_user.reload
        expect(answer_with_user.body).to eq "New body of answer"
      end

      it 'redirects to the updated answer' do
        patch :update, question_id: answer_with_user.question, id: answer_with_user, answer: attributes_for(:answer)
        expect(response).to redirect_to [:question, :answer]
      end
    end

    context 'invalid attributes' do
      before { patch :update, question_id: answer_with_user.question, id: answer_with_user, answer: { body: nil } }

      it 'does not change answer attributes' do
        answer_with_user.reload
        expect(answer_with_user.body).to eq "User's answer"
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in_user(answer_with_user.user) }

    it 'deletes answer' do
      expect { delete :destroy, question_id: answer_with_user.question, id: answer_with_user }.to change(Answer, :count).by(-1)
    end

    it 'redirects to index view' do
      delete :destroy, question_id: answer_with_user.question, id: answer_with_user
      expect(response).to redirect_to question_answers_path
    end
  end
end
