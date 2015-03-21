require_relative 'acceptance_helper'

feature 'Create answer', %q{
  In order to get Reputation
  As an authenticated user
  I want to be able to post an answer
}do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

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

  scenario 'Non-authenticated user can not see Create link for an answer' do
    visit question_path(question)

    expect(page).to_not have_field('Your answer')
    expect(page).to_not have_link('Create')
  end

  scenario 'User tries to create invalid answer using AJAX', js: true do
    sign_in(user)

    visit question_path(question)
    click_on 'Create'

    expect(page).to have_content "Body can't be blank"
  end
end