module VotableController
  extend ActiveSupport::Concern

  def vote
    @resource.vote(current_user, params[:value])
    render 'vote'
  end

  def unvote
    @resource.unvote(current_user)
    render 'vote'
  end
end