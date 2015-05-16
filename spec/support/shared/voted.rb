shared_examples 'voted' do
  let(:not_author) { create(:user) }

  describe 'POST #vote' do
    let(:vote_up) { post :vote, { id: votable.id, value: 1, format: :js }.merge(options) }
    let(:vote_down) { post :vote, { id: votable.id, value: -1, format: :js }.merge(options) }

    context 'valid user' do
      before { sign_in_user(not_author) }

      it 'votes UP for the answer' do
        expect { vote_up }.to change(Vote, :count).by(1)
      end

      it 'votes DOWN for the answer' do
        expect { vote_down }.to change(Vote, :count).by(1)
      end
    end

    context 'invalid user' do
      before { sign_in_user(votable.user) }

      it 'can not vote UP for the answer' do
        expect { vote_up }.not_to change(Vote, :count)
        expect(response).to redirect_to root_path
      end

      it 'can not vote DOWN for the answer' do
        expect { vote_down }.not_to change(Vote, :count)
        expect(response).to redirect_to root_path
      end
    end

    context 'guest user' do
      it 'can not vote UP for the answer' do
        expect { vote_up }.not_to change(Vote, :count)
        expect(response).to have_http_status(:unauthorized)
      end

      it 'can not vote DOWN for the answer' do
        expect { vote_down }.not_to change(Vote, :count)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #unvote' do
    let(:unvote) { post :unvote, { id: votable.id, format: :js }.merge(options) }

    before do
      create(
        :vote,
        user_id: not_author.id,
        votable_id: votable.id,
        votable_type: votable.class.name)
    end

    context 'valid user' do
      before { sign_in_user(not_author) }

      it 'unvotes' do
        expect { unvote }.to change(Vote, :count).by(-1)
      end
    end

    context 'invalid user' do
      before { sign_in_user(votable.user) }

      it 'can not unvote' do
        expect { unvote }.not_to change(Vote, :count)
        expect(response).to redirect_to root_path
      end
    end

    context 'guest user' do
      it 'can not unvote' do
        expect { unvote }.not_to change(Vote, :count)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
