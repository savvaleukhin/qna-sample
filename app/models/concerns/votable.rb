module Votable
  extend ActiveSupport::Concern

  def vote(user, value)
    if self.voted_by?(user)
      Vote.transaction do
        Vote.where(votable_id: self.id, votable_type: self.class.name, user_id: user.id).delete_all
        Vote.create(votable_id: self.id, votable_type: self.class.name, user_id: user.id, value: value)
      end
    else
      Vote.create(votable_id: self.id, votable_type: self.class.name, user_id: user.id, value: value)
    end
  end

  def unvote(user)
    user.votes.where(votable: self).delete_all if self.voted_by?(user)
  end

  def voted_by?(user)
    user.votes.where(votable: self).any?
  end

  def total_votes
    Vote.where(votable_id: self.id, votable_type: self.class.name).sum(:value)
  end

  def vote_by(user)
    Vote.find_by(votable_id: self.id, votable_type: self.class.name).value
  end
end