require_relative 'acceptance_helper'

feature 'Create answer', %q{
  In order to get Reputation
  As an authenticated user
  I want to be able to post an answer
}do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

=begin
  scenario 'Authenticated user creates an answer' do
    sign_in(user)

    visit question_path(question)
    click_on 'Post your answer'
    fill_in 'Body', with: 'My new answer'
    click_on 'Save'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'My new answer'
  end
=end

  scenario 'Authenticated user creates an answer using AJAX', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'Your answer', with: 'My answer'
    click_on 'Create'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'My answer'
    end
  end

=begin
  scenario 'Non-authenticated user tries to create an answer' do

    visit question_path(question)
    click_on 'Post your answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
=end
  scenario 'Non-authenticated user can not create an answer' do
    visit question_path(question)

    expect(page).to_not have_field('Your answer')
    expect(page).to_not have_selector(:link_or_button, 'Create')
  end
end