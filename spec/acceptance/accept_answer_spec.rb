require_relative 'acceptance_helper'

feature 'Accept answer', %q{
  In order to determine the best answer for the question
  user can mark one answer as Accepted.
}do

  given(:user) { create(:user) }
  given(:user_non_owner) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, user: user, question: question, body: 'Accepted answer') }
  given(:answers) { create_list(:answer, 2, user: user, question: question) }

  scenario 'Authenticated user (owner of question) marks the answer as Accepted', js: true do
    sign_in(user)

    visit question_path(answer.question)
    click_on 'Accept'
    expect(page).to have_selector('div', '.accepted-answer')
  end

  scenario 'Non-authenticated user does not see Accept link' do
    visit question_path(answer.question)
    expect(page).to_not have_link 'Accept'
  end

  scenario 'Authenticated user (not owner of question) does not see Accept link' do
    sign_in(user_non_owner)

    visit question_path(answer.question)
    expect(page).to_not have_link 'Accept'
  end

  scenario 'Accepted answer is the first answer on the page', js: true do
    sign_in(user)
    answers

    visit question_path(answer.question)
    within "#answer-#{answer.id}" do
      click_on 'Accept'
    end

    first_answer_on_page = page.find('.answers .answer:first-child')

    expect(page).to have_selector('.answer', count: 3)
    expect(first_answer_on_page).to have_content answer.body
  end
end