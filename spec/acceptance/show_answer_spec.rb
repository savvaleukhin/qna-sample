require 'rails_helper'

feature 'Show an answer', %q{
  User be able to see answer details
}do

  given(:question) { create(:question) }
  given(:answer) { create(:answer_with_question, question: question) }

  scenario 'User sees a posted answer' do
    visit question_answer_path(answer.question, answer)

    expect(page).to have_content Answer.last.body
  end
end