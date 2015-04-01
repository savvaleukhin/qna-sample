class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create, :accept]
  before_action :load_answer, only: [:update, :destroy, :accept]
  before_action :correct_user, only: [:update, :destroy]
  before_action :question_owner, only: :accept

  def create
    @answer = @question.answers.build(answer_params.merge({user_id: current_user.id}))
    #@question.save

    respond_to do |format|
      if @answer.save
        format.js
        format.json { render json: @answer }
      else
        format.js
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @question = @answer.question
    @answer.destroy
  end

  def accept
    @answer.accept
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find_by!(question_id: params[:question_id], id: params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end

  def correct_user
    unless @answer.user == current_user
      redirect_to root_path, notice: 'You do not have permission to view this page.'
    end
  end

  def question_owner
    unless @question.user_id == current_user.id
      render text: 'You do not have permission to view this page.', status: 403
    end
  end
end
