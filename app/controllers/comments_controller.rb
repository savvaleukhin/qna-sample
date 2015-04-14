class CommentsController < ApplicationController

  def create
    @comment = @commentable.comments.new(comments_params)
    @comment.user = current_user
    @comment.save
    redirect_to(:back)
  end

  private

  def comments_params
    params.require(:comment).permit(:body)
  end
end
