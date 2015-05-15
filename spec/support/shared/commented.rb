shared_examples 'commented' do
  let(:user) { commentable.user }

  context 'Valid attributes' do
    before { sign_in_user(user) }

    let(:post_comment) do
      post_comment_for(comment: attributes_for(:comment))
    end

    it 'saves a new comment in the database' do
      expect { post_comment }.to change(Comment, :count).by(1)
    end

    it 'associates the new comment with the object' do
      expect { post_comment }.to change(commentable.comments, :count).by(1)
    end

    it 'response' do
      post_comment
      expect(response.status).to eq 204
    end
  end

  context 'Invalid attributes' do
    before { sign_in_user(user) }

    let(:post_comment) do
      post_comment_for(comment: attributes_for(:invalid_comment))
    end

    it 'does not save a new comment in the database' do
      expect { post_comment }.to_not change(Comment, :count)
    end

    it 'unprocessable entity' do
      post_comment
      expect(response.status).to eq 422
    end
  end

  context 'Non authenticated user' do
    it 'does not save a new comment in the database' do
      expect { post_comment_for(comment: attributes_for(:comment)) }.to_not change(Comment, :count)
    end
  end
end
