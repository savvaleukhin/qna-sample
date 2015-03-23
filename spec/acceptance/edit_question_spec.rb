require_relative 'acceptance_helper'

feature 'Edit question', %q{
  User be able to change his question
}do

  given(:question) { create(:question_with_user) }
  given(:user_non_owner) { create(:user) }

  scenario 'Non-authenticated user does not see Edit link' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Authenticated user (not the owner) tries to edit a question' do
    sign_in(user_non_owner)
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Authenticated user (owner) tries to edit a questions', js: true do
    sign_in(question.user)
    visit question_path(question)

    within '.question' do
      click_on 'Edit'
      fill_in 'Title', with: 'Modified question'
      fill_in 'Body', with: 'body of modified question'
      click_on 'Save'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
      expect(page).to have_content 'Modified question'
      expect(page).to have_content 'body of modified question'
      expect(page).to_not have_selector 'form'
    end
  end
end