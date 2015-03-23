require_relative 'acceptance_helper'

feature 'Accept answer', %q{
  In order to determine the best answer for the question
  user can mark one answer as Accepted.
}do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, user: user, question: question) }

  scenario 'Authenticated user (owner of question) marks the answer as Accepted' do
    sign_in(user)

    visit question_path(answer.question)
    click_on 'Accept'
    expect(page).to have_selector('div', '.accepted-answer')
  end
end