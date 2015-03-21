require_relative 'acceptance_helper'

feature 'Show an answer', %q{
  User be able to see answer details
}do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, body: 'Answer for show test', user: user) }

  scenario 'User sees a posted answer' do
    visit question_answer_path(answer.question, answer)

    expect(page).to have_content 'Answer for show test'
  end
end