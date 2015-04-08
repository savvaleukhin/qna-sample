module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote(user, value)
    vote = votes.find_or_initialize_by(user: user)
    vote.value = value
    vote.save!
  end

  def unvote(user)
    user.votes.where(votable: self).delete_all
  end

  def voted_by?(user)
    user.votes.where(votable: self).any?
  end

  def total_votes
    Vote.where(votable_id: id, votable_type: self.class.name).sum(:value)
  end

  def vote_by(user)
    vote = Vote.find_by(votable_id: id, votable_type: self.class.name, user_id: user.id)
    vote.value unless vote.nil?
  end
end
