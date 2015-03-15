require 'rails_helper'

feature 'Create answer', %q{
  In order to get Reputation
  As an authenticated user
  I want to be able to post an answer
}do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user creates a question' do
    sign_in(user)
    question

    visit question_path(question)
    click_on 'Post your answer'
    fill_in 'Body', with: 'My answer'
    click_on 'Create'

    expect(page).to have_content 'Your answer successfully created.'
  end

  scenario 'Non-authenticated user tries to create a question' do
    question

    visit question_path(question)
    click_on 'Post your answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end