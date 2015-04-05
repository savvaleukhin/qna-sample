require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:non_author) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }

  describe 'GET #index' do
    let(:questions) { create_list(:question_with_user, 2) }

    before { get :index }

    it 'populate an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
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

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'builds a new attachment for the answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it 'redners show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { sign_in_user(author) }
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'builds a new attachment for the question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { sign_in_user(question.user) }
    before { get :edit, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'redners edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { sign_in_user(author) }

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
    before { sign_in_user(question.user) }

    context 'valid attributes' do
      it 'assign the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, id: question, question: { title: 'new_title', body: 'new_body' }, format: :js
        question.reload
        expect(question.title).to eq 'new_title'
        expect(question.body).to eq 'new_body'
      end

      it 'renders update template' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do
      before { patch :update, id: question, question: { title: 'new_title', body: nil }, format: :js }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 're-renders update template' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'valid user' do
      before { sign_in_user(question.user) }

      describe 'using HTML' do
        it 'deletes the question' do
          expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
        end

        it 'redirect to index view' do
          delete :destroy, id: question
          expect(response).to redirect_to questions_path
        end
      end

      describe 'using AJAX' do
        it 'deletes the question' do
          expect { delete :destroy, id: question, format: :js }.to change(Question, :count).by(-1)
        end

        it 'renders destroy template' do
          delete :destroy, id: question, format: :js
          expect(response).to render_template :destroy
        end
      end
    end

    context 'invalid user' do
      before { sign_in_user(non_author) }

      it 'can not to delete the question' do
        question
        expect { delete :destroy, id: question }.not_to change(Question, :count)
      end

      it 'redirects to root path' do
        delete :destroy, id: question
        expect(response).to redirect_to root_path
      end
    end

    context 'guest user' do
      it 'can not to delete the question' do
        question
        expect { delete :destroy, id: question }.not_to change(Question, :count)
      end

      it 'redirects to sign in page' do
        delete :destroy, id: question
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #vote' do
    context 'valid user' do
      before { sign_in_user(non_author) }

      it 'votes UP for the answer' do
        expect { post :vote, id: question, value: 1, format: :js }.to change(Vote, :count).by(1)
      end

      it 'votes DOWN for the answer' do
        expect { post :vote, id: question, value: -1, format: :js }.to change(Vote, :count).by(1)
      end
    end

    context 'invalid user' do
      before { sign_in_user(question.user) }

      it 'can not vote for the answer' do
        expect { post :vote, id: question, value: 1, format: :js }.not_to change(Vote, :count)
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'guest user' do
      it 'can not vote for the answer' do
        expect { post :vote, id: question, value: 1, format: :js }.not_to change(Vote, :count)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #unvote' do
    before { create(:vote, user_id: non_author.id, votable_id: question.id, votable_type: question.class.name) }

    context 'valid user' do
      before { sign_in_user(non_author) }

      it 'unvotes' do
        expect { post :unvote, id: question, format: :js }.to change(Vote, :count).by(-1)
      end
    end

    context 'invalid user' do
      before { sign_in_user(question.user) }

      it 'can not unvote' do
        expect { post :unvote, id: question, format: :js }.not_to change(Vote, :count)
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'guest user' do
      it 'can not unvote' do
        expect { post :unvote, id: question, format: :js }.not_to change(Vote, :count)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
