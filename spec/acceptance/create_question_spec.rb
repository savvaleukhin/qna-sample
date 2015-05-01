require_relative 'acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask a question
}do

  given(:user) { create(:user) }

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

  scenario 'Non-authenticated user tries to create a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end