class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, except: :show
  before_action :load_answer, only: :show

  def index
    respond_with @question.answers, each_serializer: AnswerPreviewSerializer
  end

  def show
    respond_with @answer
  end

  def create
    @answer = @question.answers.create(answer_params.merge(user_id: current_resource_owner.id))
    respond_with(@question, @answer)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
