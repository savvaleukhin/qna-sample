require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:steve) { create(:user) }
  let(:bob) { create(:user) }
  let(:joe) { create(:user) }
  let(:question) { create(:question, user: steve) }
  let(:answer) { create(:answer, user: joe) }
  let(:question_file) { create(:attachment, attachmentable: question) }
  let(:answer_file) { create(:attachment, attachmentable: answer) }

  describe 'DELETE #destroy' do
    context 'valid user for questions attachment' do
      before do
        sign_in_user(steve)
        question_file
      end

      it 'deletes an attachment' do
        expect { delete :destroy, id: question_file, format: :js }.to change(Attachment, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, id: question_file, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'invalid user for questions attachment' do
      before do
        sign_in_user(bob)
        question_file
      end

      it 'can not to delete an attachment' do
        expect { delete :destroy, id: question_file, format: :js }.not_to change(Attachment, :count)
      end

      it 'forbidden' do
        delete :destroy, id: question_file, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'guest user for questions attachment' do
      before { question_file }

      it 'can not to delete an attachment' do
        expect { delete :destroy, id: question_file, format: :js }.not_to change(Attachment, :count)
      end

      it 'unauthorized' do
        delete :destroy, id: question_file, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context 'valid user for answer attachment' do
    before do
      sign_in_user(joe)
      answer_file
    end

    it 'deletes an attachment' do
      expect { delete :destroy, id: answer_file, format: :js }.to change(Attachment, :count).by(-1)
    end

    it 'renders destroy template' do
      delete :destroy, id: answer_file, format: :js
      expect(response).to render_template :destroy
    end
  end

  context 'invalid user for answer attachment' do
    before do
      sign_in_user(steve)
      answer_file
    end

    it 'can not to delete attachment' do
      expect { delete :destroy, id: answer_file, format: :js }.not_to change(Attachment, :count)
    end

    it 'forbidden' do
      delete :destroy, id: answer_file, format: :js
      expect(response).to have_http_status :forbidden
    end
  end

  context 'guest user for answer attachment' do
    before { answer_file }

    it 'can not to delete attachment' do
      expect { delete :destroy, id: answer_file, format: :js }.not_to change(Attachment, :count)
    end

    it 'unauthorized' do
      delete :destroy, id: answer_file, format: :js
      expect(response).to have_http_status :unauthorized
    end
  end
end
