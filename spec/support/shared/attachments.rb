shared_examples 'attachment that can be destroyed' do
  let(:attachment) { create(:attachment, attachmentable: attachmentable) }
  let(:destroy_attachment) do
    delete :destroy, id: attachment, format: :js
  end

  context 'Valid user' do
    before do
      sign_in_user(attachmentable.user)
      attachment
    end

    it 'deletes an attachment' do
      expect { destroy_attachment }.to change(Attachment, :count).by(-1)
    end

    it 'renders destroy template' do
      destroy_attachment
      expect(response).to render_template :destroy
    end
  end

  context 'Invalid user' do
    let(:wrong_user) { create(:user) }

    before do
      sign_in_user(wrong_user)
      attachment
    end

    it 'can not to delete an attachment' do
      expect { destroy_attachment }.not_to change(Attachment, :count)
    end

    it 'redirects to root url' do
      destroy_attachment
      expect(response).to redirect_to root_path
    end
  end

  context 'Guest user' do
    before { attachment }

    it 'can not to delete an attachment' do
      expect { destroy_attachment }.not_to change(Attachment, :count)
    end

    it 'unauthorized' do
      destroy_attachment
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
