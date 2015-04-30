class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable
  before_action :load_comment, only: [:update, :destroy]
  before_action :correct_user, only: [:update, :destroy]

  respond_to :json

  def create
    @comment = @commentable.comments.create(comments_params.merge(user_id: current_user.id))

    respond_with @comment do |format|
      format.json do
        PrivatePub.publish_to(
          commentable_channel,
          comment: @comment.to_json,
          method: 'POST'
        )
        head :no_content
      end if @comment.errors.empty?
    end
  end

  def update
    @comment.update(comments_params)
    respond_with @comment do |format|
      format.json do
        PrivatePub.publish_to(
          commentable_channel,
          comment: @comment.to_json,
          method: 'PATCH'
        )
        head :no_content
      end if @comment.errors.empty?
    end
  end

  def destroy
    respond_with(@comment.destroy) do |format|
      format.json do
        PrivatePub.publish_to(
          commentable_channel,
          comment: @comment.to_json,
          method: 'DELETE'
        )
        head :no_content
      end if @comment.errors.empty?
    end
  end

  private

  def load_commentable
    model = params[:commentable].classify.constantize
    parameter = (params[:commentable].singularize + '_id').to_sym
    @commentable = model.find(params[parameter])
  end

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def commentable_channel
    "/questions/#{ @commentable.try(:question).try(:id) || @commentable.id }/comments"
  end

  def correct_user
    return if @comment.user == current_user
    render text: 'You do not have permission to view this page.', status: 403
  end

  def comments_params
    params.require(:comment).permit(:body)
  end
end
