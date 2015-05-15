shared_examples 'comment that can be created' do
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

shared_examples 'comment that can be updated' do
  context 'Valid attributes' do
    before { sign_in_user(comment.user) }

    let(:update_comment) do
      update_comment_for(comment: { body: 'New comment' })
    end

    it 'changes comment attributes' do
      update_comment
      comment.reload
      expect(comment.body).to eq 'New comment'
    end

    it 'response' do
      update_comment
      expect(response.status).to eq 204
    end
  end

  context 'Invalid attributes' do
    let(:update_comment) do
      update_comment_for(comment: { body: nil })
    end

    it 'does not change the comment in the database' do
      update_comment
      comment.reload
      expect(comment.body).to eq 'My comment'
    end
  end
end

shared_examples 'comment that can be destroyed' do
  context 'valid user' do
    before { sign_in_user(comment.user) }

    it 'deletes the comment' do
      expect { delete_comment }.to change(Comment, :count).by(-1)
    end
  end

  context 'invalid user' do
    let(:user) { create(:user) }

    before { sign_in_user(user) }

    it 'can not to delete the comment' do
      comment
      expect { delete_comment }.not_to change(Answer, :count)
    end

    it 'redirects to root url' do
      delete_comment
      expect(response).to redirect_to root_url
    end
  end

  context 'guest user' do
    it 'can not to delete the comment' do
      comment
      expect { delete_comment }.not_to change(Answer, :count)
    end

    it 'response unauthorized' do
      delete_comment
      expect(response.status).to eq 401
    end
  end
end
