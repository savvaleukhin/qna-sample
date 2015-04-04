module Votable
  extend ActiveSupport::Concern

  def vote(user, value)
   vote = user.votes.find_by(votable: self)

    if vote.nil?
      user.votes.create(votable: self, value: value)
    else
      vote.destroy
    end
  end

  def total_votes
    Vote.where(votable_id: self.id, votable_type: self.class.name).sum(:value)
  end
end