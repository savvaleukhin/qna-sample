require 'rails_helper'

feature 'Edit question', %q{
  User be able to change his question
}do

  given(:question_with_user) { create(:question_with_user) }
  given(:user_non_owner) { create(:user) }

  scenario 'Non-authenticated user tries to edit a question' do
    visit edit_question_path(question_with_user)

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user (not the owner) tries to edit a question' do
    sign_in(user_non_owner)

    visit edit_question_path(question_with_user)

    expect(page).to have_content 'You do not have permission to view this page.'
    expect(current_path).to eq root_path
  end

  scenario 'Authenticated user (owner) edits a question' do
    sign_in(question_with_user.user)

    visit edit_question_path(question_with_user)
    fill_in 'Title', with: 'Modified question'
    click_on 'Save'

    expect(page).to have_content 'Modified question'
  end
end