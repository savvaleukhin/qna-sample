require_relative 'acceptance_helper'

feature 'Delete a question', %q{
  User be able to delete his question
}do

  given(:question_with_user) { create(:question_with_user) }
  given(:user_non_owner) { create(:user) }

  scenario 'Non-authenticated user tries to delete a question' do
    visit question_path(question_with_user)
    expect(page).to_not have_link 'Delete'
  end

  scenario 'Authenticated user (not the owner) tries to delete a question' do
    sign_in(user_non_owner)
    visit question_path(question_with_user)

    expect(page).to_not have_link 'Delete'
  end

  scenario 'Authenticated user (owner) delete a question' do
    sign_in(question_with_user.user)
    visit question_path(question_with_user)

    within '.question' do
      click_on 'Delete'
    end

    expect(page).to_not have_content 'MyString'
    expect(page).to_not have_content 'MyText'
    expect(page).to have_content 'Question was successfully destroyed.'
    expect(current_path).to eq questions_path
  end

  scenario 'Authenticated user (owner) delete a question using AJAX', js: true do
    sign_in(question_with_user.user)
    visit questions_path

    within '.questions' do
      click_on 'Delete'
    end

    expect(page).to_not have_content 'MyString'
    expect(current_path).to eq questions_path
  end
end