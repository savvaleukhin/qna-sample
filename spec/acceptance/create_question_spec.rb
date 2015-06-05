require_relative 'acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask a question
}do

  given(:user) { create(:user) }

  context 'Authenticated user' do
    scenario 'Authenticated user creates a question' do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
      fill_in 'Title', with: 'My new question'
      fill_in 'Body', with: 'test text'
      click_on 'Save'

      expect(page).to have_content 'Question was successfully created.'
      expect(page).to have_content 'My new question'
    end

    scenario 'Authenticated user cancels creating process' do
      sign_in(user)
      visit questions_path
      click_on 'Ask question'
      click_on 'Cancel'

      expect(current_path).to eq questions_path
    end

    scenario 'Tries to create invalid question' do
      sign_in(user)

      visit new_question_path
      click_on 'Save'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank "
    end
  end

  scenario 'Non-authenticated user tries to create a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end