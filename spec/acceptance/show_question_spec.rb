require_relative 'acceptance_helper'

feature 'Show list of questions', %q{
  User be able to see list of asked questions
} do

  title_1 = 'question test 1'
  title_2 = 'question test 2'
  given(:user) { create(:user) }

  scenario 'User sees the list of questions' do
    create(:question, title: title_1, user: user)
    create(:question, title: title_2, user: user)

    visit questions_path

    expect(page).to have_content title_1
    expect(page).to have_content title_2
  end
end

feature 'Show a question', %q{
  User be able to see asked question with answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, title: 'question test', body: 'body of question test', user: user) }

  scenario 'User sees a question and list of answers' do
    question.answers.create!([{body: 'test 1', user: user}, {body: 'test 2', user: user}])

    visit question_path(question)
    expect(page).to have_content 'question test'
    expect(page).to have_content 'body of question test'
    expect(page).to have_content 'test 1'
    expect(page).to have_content 'test 2'
  end

  scenario 'User sees a question without any answers' do
    visit question_path(question)
    expect(page).to have_content 'question test'
    expect(page).to have_content 'body of question test'
    within '.answers' do
      expect(page).to_not have_selector('table')
    end
  end
end