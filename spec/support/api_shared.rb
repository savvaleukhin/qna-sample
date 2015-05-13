shared_examples 'api get request' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      get path, format: :json
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      get path, format: :json, access_token: '1234'
      expect(response.status).to eq 401
    end
  end
end

shared_examples 'api post request' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      post path, resource.to_sym => attributes, format: :json
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      post path, resource.to_sym => attributes, format: :json, access_token: '1234'
      expect(response.status).to eq 401
    end
  end
end
