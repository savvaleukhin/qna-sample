require 'rails_helper'

RSpec.describe OmniauthRegistrationsController, type: :controller do
  let(:user) { create(:user, email: 'test@test.com') }
  let(:auth_twitter) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456', info: {}) }
  let(:post_email) { post :create, email: 'test@test.com'}
  let(:post_invalid_email) { post :create, email: nil}


  describe 'POST #create' do
    context 'Existent user' do
      before do
        user
        session['devise.omniauth'] = auth_twitter
      end

      it 'does not save new authorization for user in the database' do
        expect { post_email }.to_not change(user.authorizations, :count)
      end

      it 'redirects to new_user_session_path' do
        post_email
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'New user' do
      context 'Valid attributes' do
        before { session['devise.omniauth'] = auth_twitter }

        it 'saves new user in the database' do
          expect { post_email }.to change(User, :count).by(1)
        end

        it 'saves new authorization in the database' do
          expect { post_email }.to change(Authorization, :count).by(1)
        end
      end

      context 'Invalid attributes' do
        context 'Invalid OmniAuth Hash' do
          before { session['devise.omniauth'] = nil }

          it 'does not save new user in the database' do
            expect { post_email }.to_not change(User, :count)
          end

          it 'does not save new authorization in the database' do
            expect { post_email }.to_not change(Authorization, :count)
          end

          it 'redirects to new_user_session_path' do
            post_email
            expect(response).to redirect_to new_user_session_path
          end
        end

        context 'Invalid email' do
          before { session['devise.omniauth'] = auth_twitter }

          it 'does not save new user in the database' do
            expect { post_invalid_email }.to_not change(User, :count)
          end

          it 'does not save new authorization in the database' do
            expect { post_invalid_email }.to_not change(Authorization, :count)
          end

          it 'rerenders new view' do
            post_invalid_email
            expect(response).to render_template :new
          end
        end
      end
    end
  end
end
