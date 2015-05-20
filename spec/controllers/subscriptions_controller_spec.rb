require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do

  describe "POST #create" do
    let(:question) { create(:question_with_user) }
    let(:user) { create(:user) }
    let(:create_subscription) do
      post :create, question_id: question.id, subscriber_id: user.id, format: :js
    end

    context 'Authenticated user' do
      before { sign_in_user(user) }

      it 'saves new subscription in the Database' do
        expect { create_subscription }.to change(Subscription, :count).by(1)
      end

      it 'associates the new subscription with user' do
        expect { create_subscription }.to change(user.tracking_questions, :count).by(1)
      end

      it 'associates the new subscription with the question' do
        expect { create_subscription }.to change(question.subscribers, :count).by(1)
      end

      it 'responses 200' do
        create_subscription
        expect(response.status).to eq 200
      end
    end

    context 'Non-authenticated user' do
      it 'responses 401' do
        create_subscription
        expect(response.status).to eq 401
      end
    end
  end

  describe "DELETE #destroy" do
    let(:question) { create(:question_with_user) }
    let(:user) { create(:user) }
    let!(:subscription) { create(:subscription, subscriber: user, tracking_question: question) }
    let(:delete_subscription) do
      delete :destroy, question_id: question.id, id: subscription, format: :js
    end

    context 'Valid user' do
      before { sign_in_user(user) }

      it 'deletes the subscription' do
        expect { delete_subscription }.to change(Subscription, :count).by(-1)
      end

      it 'renders destroy tempate' do
        delete_subscription
        expect(response).to render_template :destroy
      end
    end

    context 'Invalid user' do
      let(:other) { create(:user) }
      before { sign_in_user(other) }

      it 'can not to delete the subscription' do
        expect { delete_subscription }.not_to change(Subscription, :count)
      end

      it 'redirects to root path' do
        delete_subscription
        expect(response).to redirect_to root_path
      end
    end

    context 'guest user' do
      it 'can not to delete the subscription' do
        expect { delete_subscription }.not_to change(Subscription, :count)
      end

      it 'responses 401' do
        delete_subscription
        expect(response.status).to eq 401
      end
    end
  end
end
