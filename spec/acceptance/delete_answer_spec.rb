require 'rails_helper'

feature 'Delete an answer', %q{
  User be able to delete his answer
}do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer_with_user) { create(:answer, user: user, question: question) }
  given(:user_non_owner) { create(:user) }

  scenario 'Non-authenticated user tries to delete an answer' do
    visit question_answer_path(answer_with_user.question, answer_with_user)
    expect(page).to_not have_selector(:link_or_button, 'Delete')
  end

  scenario 'Authenticated user (not the owner) tries to delete an answer' do
    sign_in(user_non_owner)
    visit question_answer_path(answer_with_user.question, answer_with_user)

    expect(page).to_not have_selector(:link_or_button, 'Delete')
  end

  scenario 'Authenticated user (owner) delete an answer' do
    sign_in(answer_with_user.user)
    visit question_answer_path(answer_with_user.question, answer_with_user)
    click_on 'Delete'

    expect(page).to have_content 'Your answer was successfully deleted.'
    expect(current_path).to eq question_answers_path(answer_with_user.question)
  end  
end