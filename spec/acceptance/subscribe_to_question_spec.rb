require_relative 'acceptance_helper'

feature 'Subscribe to question', %q{
  In order to get notifications,
  when there is a new  answer for question,
  user be able to subscribe to the question
}do
  given(:user) { create(:user) }
  given(:question) { create(:question_with_user) }
  given(:answer) { crerate(:answer, question: question, user: question.user) }
  given(:subscription) { create(:subscription, tracking_question: question, subscriber: user) }

  scenario 'Authenticated user subscribe to the question', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Subscribe'

    expect(page).to_not have_selector(:link_or_button, 'Subscribe')
    expect(page).to have_link 'Unsubscribe'
  end

  scenario 'Authenticated user unsubscribe from the question', js: true do
    subscription
    sign_in(user)
    visit question_path(question)

    click_on 'Unsubscribe'
    expect(page).to_not have_link 'Unsubscribe'
    expect(page).to have_selector(:link_or_button, 'Subscribe')
  end

  scenario 'Non-authenticated user does not see Subscribe/Unsubscribe links' do
    visit question_path(question)
    expect(page).to_not have_link 'Subscribe'
    expect(page).to_not have_link 'Unsubscribe'
  end
end
