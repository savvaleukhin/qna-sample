require_relative 'acceptance_helper'

feature 'Delete an answer', %q{
  User be able to delete his answer
}do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, user: user, question: question) }
  given(:user_non_owner) { create(:user) }

  scenario 'Non-authenticated user tries to delete an answer' do
    visit question_path(answer.question)

    within '.answers' do
      expect(page).to_not have_selector(:link_or_button, 'Delete')
    end
  end

  scenario 'Authenticated user (not the owner) tries to delete an answer' do
    sign_in(user_non_owner)
    visit question_path(answer.question)

    within '.answers' do
      expect(page).to_not have_selector(:link_or_button, 'Delete')
    end
  end

  scenario 'Authenticated user (owner) delete an answer' do
    sign_in(answer.user)
    visit question_path(answer.question)

    within '.answers' do
      click_on 'Delete'
    end

    expect(page).to have_content 'Your answer was successfully deleted.'
    expect(current_path).to eq question_path(answer.question)
  end
end