require 'rails_helper'

feature 'Show list of questions', %q{
  User be able to see list of asked questions
} do

  given(:question_list) { create_list(:question_list, 2) }

  scenario 'User sees the list of questions' do
    question_list

    visit questions_path

    expect(page).to have_content 'Question #1'
    expect(page).to have_content 'Question #2'
  end
end

feature 'Show a question', %q{
  User be able to see asked question with answers
} do

  given(:question) { create(:question_with_answers) }

  scenario 'User sees a question and list of answers' do

    visit question_path(question)
    expect(page).to have_content 'Question with answers'
    expect(page).to have_content 'Text of question with answers'
    expect(page).to have_content Answer.where(question_id: question.id).last.body
    expect(page).to have_content Answer.where(question_id: question.id).order("id DESC").offset(1).first.body
  end
end