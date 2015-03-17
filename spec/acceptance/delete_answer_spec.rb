require 'rails_helper'

feature 'Delete an anwer', %q{
  User be able to delete his answer
}do

  given(:answer_with_user) { create(:answer_with_user) }
  given(:user_non_owner) { create(:user) }

  scenario 'Non-authenticated user tries to delete an answer' do
    page.driver.submit :delete, question_answer_path(answer_with_user.question, answer_with_user), {}

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end

  scenario 'Authenticated user (not the owner) tries to delete an answer' do
    sign_in(user_non_owner)

    page.driver.submit :delete, question_answer_path(answer_with_user.question, answer_with_user), {}

    expect(page).to have_content 'You do not have permission to view this page.'
    expect(current_path).to eq root_path
  end

  scenario 'Authenticated user (owner) delete an answer' do
    sign_in(answer_with_user.user)

    page.driver.submit :delete, question_answer_path(answer_with_user.question, answer_with_user), {}

    expect(page).to have_content 'Your answer was successfully deleted.'
    expect(current_path).to eq question_answers_path(answer_with_user.question)
  end
end