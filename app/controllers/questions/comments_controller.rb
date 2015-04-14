class Questions::CommentsController < CommentsController
  before_action :load_commentable

  private

  def load_commentable
    @commentable = Question.find(params[:question_id])
  end
end
