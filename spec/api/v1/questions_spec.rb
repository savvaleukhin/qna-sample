require 'rails_helper'

describe 'Questions API' do
  describe 'GET/index' do
    it_behaves_like 'api' do
      let(:path) { '/api/v1/questions' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:questions) { create_list(:question_with_user, 2) }
      let(:question) { questions.first }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      context 'question preview' do
        %w{id title created_at updated_at user_id}.each do |attr|
          it "contains question object #{attr}" do
            expect(response.body).to(
              be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
            )
          end
        end
      end
    end
  end

  describe 'GET/show' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, user: user, question: question) }
    let!(:comment) { create(:comment, user: user, commentable: question) }
    let!(:attachment) { create(:attachment, attachmentable: question) }

    it_behaves_like 'api' do
      let(:path) { "/api/v1/questions/#{question.id}" }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token
      end

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w{id title body created_at updated_at}.each do |attr|
        it "contains question object #{attr}" do
          expect(response.body).to(
            be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
          )
        end
      end

      context 'answers' do
        it 'includes in question object' do
          expect(response.body).to have_json_size(1).at_path('question/answers')
        end

        %w{id body created_at updated_at user_id accepted}.each do |attr|
          it "contains #{attr}" do
            expect(response.body).to(
              be_json_eql(answer.send(attr.to_sym).to_json).at_path("question/answers/0/#{attr}")
            )
          end
        end
      end

      context 'comments' do
        it 'includes in question object' do
          expect(response.body).to have_json_size(1).at_path('question/comments')
        end

        %w{id body created_at updated_at user_id}.each do |attr|
          it "contains #{attr}" do
            expect(response.body).to(
              be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
            )
          end
        end
      end


      context 'attachments' do
        it 'includes in question object' do
          expect(response.body).to have_json_size(1).at_path('question/attachments')
        end

        it 'contains url' do
          expect(response.body).to(
            be_json_eql(attachment.file.url.to_json).at_path('question/attachments/0/url')
          )
        end
      end
    end
  end
end
