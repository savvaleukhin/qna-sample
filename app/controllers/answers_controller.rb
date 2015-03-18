class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:index, :new, :edit]
  before_action :load_answer, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
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
    @answer = current_user.answers.build(answer_params.merge({question_id: params[:question_id]}))

    if @answer.save
      redirect_to question_answer_path(params[:question_id], @answer), notice: 'Your answer successfully created.'
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
    redirect_to question_answers_path, notice: 'Your answer was successfully deleted.'
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find_by!(question_id: params[:question_id], id: params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def correct_user
    unless @answer.user == current_user
      redirect_to root_path, notice: 'You do not have permission to view this page.'
    end
  end
end
