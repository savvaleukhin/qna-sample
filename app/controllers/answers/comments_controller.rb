class Answers::CommentsController < CommentsController
  before_action :load_commentable

  private

  def load_commentable
    @commentable = Answer.find(params[:answer_id])
  end
end
