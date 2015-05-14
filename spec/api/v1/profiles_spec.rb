require 'rails_helper'

describe 'Profile API' do
  describe 'GET/me' do
    it_behaves_like 'api resource'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it 'returns status 200' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', { format: :json }.merge(options)
    end
  end

  describe 'GET/index' do
    it_behaves_like 'api resource'

    context 'authorized' do
      let!(:user_list) { create_list(:user, 3) }
      let(:current_user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: current_user.id) }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it 'returns status 200' do
        expect(response).to be_success
      end

      it 'contains user_list' do
        expect(response.body).to be_json_eql(user_list.to_json).at_path('profiles')
      end

      it 'does not contain current_user' do
        expect(response.body).to_not include_json(current_user.to_json)
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles', { format: :json }.merge(options)
    end
  end
end
