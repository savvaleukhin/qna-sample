require 'rails_helper'

shared_examples "a api client" do
  it 'returns 401 status if there is no access_token' do
    get path, format: :json
    expect(response.status).to eq 401
  end

  it 'returns 401 status if access_token is invalid' do
    get path, format: :json, access_token: '1234'
    expect(response.status).to eq 401
  end
end

describe 'Profile API' do
  describe 'GET/me' do
    context 'unauthorized' do
      it_behaves_like "a api client" do
        let(:path) { '/api/v1/profiles/me' }
      end
    end

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
  end

  describe 'GET/index' do
    context 'unauthorized' do
      it_behaves_like "a api client" do
        let(:path) { '/api/v1/profiles' }
      end
    end

    context 'authorized' do
      let(:user_list) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: user_list.last.id) }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it 'returns status 200' do
        expect(response).to be_success
      end

      it 'contains user_list except current user' do
        expect(response.body).to have_json_size(2)
      end

      [0, 1].each do |number|
        %w(id email created_at updated_at admin).each do |attr|
          it "contains user_#{number} #{attr}" do
            expect(response.body).to(
              be_json_eql(user_list[number].send(attr.to_sym).to_json).at_path("#{number}/#{attr}")
            )
          end
        end
      end

      [0, 1].each do |number|
        %w(password encrypted_password).each do |attr|
          it "does not contain user_#{number} #{attr}" do
            expect(response.body).to_not(
              have_json_path("#{number}/#{attr}")
            )
          end
        end
      end
    end
  end
end
