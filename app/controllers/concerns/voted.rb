module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_voted, only: [:vote, :unvote]
    before_action :user_can_vote, only: [:vote, :unvote]
    before_action :authorization, only: [:vote, :unvote]
  end

  def vote
    @resource.vote(current_user, params[:value])
    render 'vote'
  end

  def unvote
    @resource.unvote(current_user)
    render 'vote'
  end

  private

  def load_voted
    @resource = controller_name.classify.constantize.find(params[:id])
  end

  def user_can_vote
    if @resource.user_id == current_user.id
      render text: 'You do not have permission to view this page.', status: 403
    end
  end

  def authorization
    authorize! :vote, @resource
  end
end
