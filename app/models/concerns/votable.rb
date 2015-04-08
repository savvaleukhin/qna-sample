module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

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
    vote = Vote.find_by(votable_id: self.id, votable_type: self.class.name)
    vote.value unless vote.nil?
  end
end