class QuestionsController < ApplicationController
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_questions_list, only: :index
  before_action :load_answers_list, only: :show

  include Voted

  authorize_resource

  respond_to :html
  respond_to :js, only: [:update, :destroy]

  def index
    respond_with @questions
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
    respond_with @question
  end

  def new
    @question = Question.new
    @question.attachments.build
    respond_with @question
  end

  def edit
  end

  def create
    @question = current_user.questions.create(question_params)

    respond_with @question do |format|
      format.html do
        redirect_to @question
        PrivatePub.publish_to '/questions', question: @question.to_json
      end if @question.errors.empty?
    end
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def load_questions_list
    @questions = Question.all
  end

  def load_answers_list
    @answers = @question.answers.includes(:comments, :attachments)
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
