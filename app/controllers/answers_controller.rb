class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create, :accept]
  before_action :load_answer, only: [:update, :destroy, :accept]
  before_action :correct_user, only: [:update, :destroy]
  before_action :question_owner, only: :accept

  include Voted

  respond_to :js, :json

  def create
    @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))

    respond_with @answer do |format|
      format.json do
        PrivatePub.publish_to(
          answers_channel,
          answer: (render template: 'answers/create.json.jbuilder')
        )
      end if @answer.errors.empty?
    end
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def accept
    @answer.accept
    @answers = @question.answers.includes(:comments, :attachments)
    respond_with(@answers)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def correct_user
    return if @answer.user == current_user
    redirect_to root_path, notice: 'You do not have permission to view this page.'
  end

  def question_owner
    return if @question.user_id == current_user.id
    render text: 'You do not have permission to view this page.', status: 403
  end

  def answers_channel
    "/questions/#{@question.id}/answers"
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end
end
