class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question
  before_action :load_subscription, only: :destroy

  authorize_resource

  respond_to :js

  def create
    @subscription = @question.subscriptions.create(subscriber_id: current_user.id)
    respond_with @subscription
  end

  def destroy
    respond_with(@subscription.destroy)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_subscription
    @subscription = Subscription.find(params[:id])
  end
end
