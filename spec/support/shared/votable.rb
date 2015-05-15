shared_examples 'votable' do
  context 'vote for object' do
    let(:user) { votable.user }

    it 'votes up' do
      vote = votable.vote(user, 1)

      expect(user.votes.find_by(votable: votable).value).to eq 1
      expect(
        Vote.where(user_id: user, votable_id: votable.id, votable_type: votable.class.name).count
      ).to eq 1
    end

    it 'votes down' do
      vote = votable.vote(user, -1)

      expect(user.votes.find_by(votable: votable).value).to eq -1
      expect(
        Vote.where(user_id: user, votable_id: votable.id, votable_type: votable.class.name).count
      ).to eq 1
    end

    it 'unvotes' do
      votable.vote(user, 1)
      unvote = votable.unvote(user)

      expect(
        Vote.where(user_id: user, votable_id: votable.id, votable_type: votable.class.name).count
      ).to eq 0
    end
  end
end
