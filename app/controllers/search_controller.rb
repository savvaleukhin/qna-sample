class SearchController < ApplicationController
  skip_authorization_check

  def search
    if params[:query].present?
      @questions = Question.search_filter(params[:query], condition: params[:condition])
    else
      @questions = []
    end
    respond_with @questions
  end
end
