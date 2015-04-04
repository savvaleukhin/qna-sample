require_relative 'acceptance_helper'

feature 'Edit anwer', %q{
  User be able to change his answer
}do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given(:user_non_owner) { create(:user) }

  scenario 'Non-authenticated user does not see Edit link' do
    visit question_path(answer.question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Authenticated user (not the owner) does not see Edit link' do
    sign_in(user_non_owner)

    visit question_path(answer.question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Authenticated user (owner) edits an answer', js: true, data: { type: :json } do
    sign_in(answer.user)

    visit question_path(answer.question)
    within '.answers' do
      click_on 'Edit'
      fill_in 'Answer', with: 'Modified answer'
      click_on 'Save'

      expect(page).to_not have_content answer.body
      expect(page).to have_content 'Modified answer'
      expect(page).to_not have_selector 'textarea'
    end
  end
end