require 'rails_helper'

feature 'Show an answer', %q{
  User be able to see answer details
}do

  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, body: 'Answer for show test') }

  scenario 'User sees a posted answer' do
    visit question_answer_path(answer.question, answer)

    expect(page).to have_content 'Answer for show test'
  end
end