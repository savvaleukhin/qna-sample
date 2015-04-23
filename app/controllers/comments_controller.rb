class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  respond_to :json

  def create
    @comment = @commentable.comments.create(comments_params.merge(user_id: current_user.id))

    respond_with @comment do |format|
      format.json do
        PrivatePub.publish_to commentable_channel, comment: @comment.to_json
        head :no_content
      end if @comment.errors.empty?
    end
  end

  private

  def comments_params
    params.require(:comment).permit(:body)
  end

  def load_commentable
    model = params[:commentable].classify.constantize
    parameter = (params[:commentable].singularize + '_id').to_sym
    @commentable = model.find(params[parameter])
  end

  def commentable_channel
    "/questions/#{ @commentable.try(:question).try(:id) || @commentable.id }/comments"
  end
end
