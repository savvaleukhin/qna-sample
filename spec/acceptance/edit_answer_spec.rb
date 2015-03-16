require 'rails_helper'

feature 'Edit anwer', %q{
  User be able to change his answer
}do

  given(:answer_with_user) { create(:answer_with_user) }
  given(:user_non_owner) { create(:user) }

  scenario 'Non-authenticated user tries to edit an answer' do
    visit edit_question_answer_path(answer_with_user.question, answer_with_user)

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user (not the owner) tries to edit an answer' do
    answer_with_user
    sign_in(user_non_owner)

    visit edit_question_answer_path(answer_with_user.question, answer_with_user)

    expect(page).to have_content 'You do not have permission to view this page.'
    expect(current_path).to eq root_path
  end

  scenario 'Authenticated user (owner) edits an answer' do
    answer_with_user
    sign_in(answer_with_user.user)

    visit edit_question_answer_path(answer_with_user.question, answer_with_user)
    fill_in 'Body', with: 'Modified answer'
    click_on 'Save'

    expect(page).to have_content 'Modified answer'
  end  
end