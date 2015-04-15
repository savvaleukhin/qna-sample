class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  def create
    @comment = @commentable.comments.new(comments_params)
    @comment.user = current_user

    if @comment.save
      render json: @comment
    else
      render json: @comment.errors.full_messages, status: 422
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
end
