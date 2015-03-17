require 'rails_helper'

feature 'Delete a question', %q{
  User be able to delete his question
}do

  given(:question_with_user) { create(:question_with_user) }
  given(:user_non_owner) { create(:user) }

  scenario 'Non-authenticated user tries to delete a question' do
    page.driver.submit :delete, question_path(question_with_user), {}

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end

  scenario 'Authenticated user (not the owner) tries to delete a question' do
    sign_in(user_non_owner)

    page.driver.submit :delete, question_path(question_with_user), {}

    expect(page).to have_content 'You do not have permission to view this page.'
    expect(current_path).to eq root_path
  end

  scenario 'Authenticated user (owner) delete a question' do
    sign_in(question_with_user.user)

    page.driver.submit :delete, question_path(question_with_user), {}

    expect(page).to have_content 'Your question was successfully deleted.'
    expect(current_path).to eq questions_path
  end  
end