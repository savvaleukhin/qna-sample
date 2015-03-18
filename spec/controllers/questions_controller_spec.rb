require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:question_with_user) { create(:question_with_user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populate an array of all questions' do
      expect(assigns(:questions)).to match_array(@questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'redners show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { sign_in_user(user) }
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { sign_in_user(question_with_user.user) }
    before { get :edit, id: question_with_user }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question_with_user
    end

    it 'redners edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { sign_in_user(user) }

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save new question in the database' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in_user(question_with_user.user) }

    context 'valid attributes' do
      it 'assign the requested question to @question' do
        patch :update, id: question_with_user, question: attributes_for(:question)
        expect(assigns(:question)).to eq question_with_user
      end

      it 'changes question attributes' do
        patch :update, id: question_with_user, question: { title: 'new_title', body: 'new_body' }
        question_with_user.reload
        expect(question_with_user.title).to eq 'new_title'
        expect(question_with_user.body).to eq 'new_body'
      end

      it 'redirects to the updated question' do
        patch :update, id: question_with_user, question: attributes_for(:question)
        expect(response).to redirect_to question_with_user
      end
    end

    context 'invalid attributes' do
      before { patch :update, id: question_with_user, question: { title: 'new_title', body: nil } }

      it 'does not change question attributes' do
        question_with_user.reload
        expect(question_with_user.title).to eq 'MyString'
        expect(question_with_user.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'valid user' do
      before { sign_in_user(question_with_user.user) }

      it 'deletes the question' do
        expect { delete :destroy, id: question_with_user }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, id: question_with_user
        expect(response).to redirect_to questions_path
      end
    end

    context 'invalid user' do
      before { sign_in_user(user) }

      it 'can not to delete the question' do
        question_with_user
        expect { delete :destroy, id: question_with_user }.not_to change(Question, :count)
      end

      it 'redirects to root path' do
        delete :destroy, id: question_with_user
        expect(response).to redirect_to root_path
      end
    end

    context 'guest user' do
      it 'can not to delete the question' do
        question_with_user
        expect { delete :destroy, id: question_with_user }.not_to change(Question, :count)
      end

      it 'redirects to sign in page' do
        delete :destroy, id: question_with_user
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
