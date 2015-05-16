require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    context 'Question attachment' do
      it_behaves_like 'attachment that can be destroyed' do
        let(:attachmentable) { create(:question_with_user) }
      end
    end

    context 'Answer attachment' do
      it_behaves_like 'attachment that can be destroyed' do
        let(:attachmentable) { create(:answer_with_user) }
      end
    end
  end
end
