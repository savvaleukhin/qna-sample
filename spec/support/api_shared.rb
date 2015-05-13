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

shared_examples 'it has comments json' do
  context 'comments' do
    it "includes comments in object" do
      expect(response.body).to have_json_size(1).at_path(resource_name + "/comments")
    end

    %w{id body created_at updated_at user_id}.each do |attr|
      it "contains #{attr}" do
        expect(response.body).to(
          be_json_eql(
            comment.send(attr.to_sym).to_json).at_path(resource_name + "/comments/0/#{attr}"
          )
        )
      end
    end
  end
end

shared_examples 'it has attachments json' do
  context 'attachments' do
    it 'includes attachments in object' do
      expect(response.body).to have_json_size(1).at_path(resource_name + '/attachments')
    end

    it 'contains url' do
      expect(response.body).to(
        be_json_eql(attachment.file.url.to_json).at_path(resource_name + '/attachments/0/url')
      )
    end
  end
end
