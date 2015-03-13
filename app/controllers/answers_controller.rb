class AnswersController < ApplicationController
  before_action :load_answer, only: [:show, :edit, :update, :destroy]

  def index
    @question = Question.find(params[:question_id])
    @answers = @question.answers
  end

  def show
  end

  def new
    @answer = Answer.new
  end

  def edit
  end

  def create
    @answer = Answer.new(answer_params.merge({question_id: params[:question_id]}))

    if @answer.save
      redirect_to question_answer_path(params[:question_id], @answer)
    else
      render :new
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to question_answer_path(params[:question_id], @answer)
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    redirect_to question_answers_path
  end

  private

  def load_answer
    @answer = Answer.find_by(question_id: params[:question_id], id: params[:id])
  end  

  def answer_params
    params.require(:answer).permit(:body)
  end
end
