require 'rails_helper'

feature 'Show list of questions', %q{
  User be able to see list of asked questions
} do
  
  given(:question) { create(:question) }
  given(:question_2) { create(:question_2) }

  scenario 'User sees the list of questions' do
    question
    question_2

    visit questions_path

    expect(page).to have_content 'MyString'
    expect(page).to have_content 'Second question'
  end
end

feature 'Show a question', %q{
  User be able to see asked question with answers
} do

  given(:question) { create(:question_with_answers) }

  scenario 'User sees a question and list of answers' do
    question

    visit question_path(question)
    expect(page).to have_content 'Question with answers'
    expect(page).to have_content 'Text of question with answers'
    expect(page).to have_content 'Answer #1'
    expect(page).to have_content 'Answer #2'
  end
end