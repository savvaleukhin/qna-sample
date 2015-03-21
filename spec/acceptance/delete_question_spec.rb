require_relative 'acceptance_helper'

feature 'Delete a question', %q{
  User be able to delete his question
}do

  given(:question_with_user) { create(:question_with_user) }
  given(:user_non_owner) { create(:user) }

  scenario 'Non-authenticated user tries to delete a question' do
    visit question_path(question_with_user)
    expect(page).to_not have_selector(:link_or_button, 'Delete')
  end

  scenario 'Authenticated user (not the owner) tries to delete a question' do
    sign_in(user_non_owner)
    visit question_path(question_with_user)

    expect(page).to_not have_selector(:link_or_button, 'Delete')
  end

  scenario 'Authenticated user (owner) delete a question' do
    sign_in(question_with_user.user)
    visit question_path(question_with_user)
    click_on 'Delete'

    expect(page).to have_content 'Your question was successfully deleted.'
    expect(current_path).to eq questions_path
  end
end