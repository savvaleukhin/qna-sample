require_relative 'acceptance_helper'

feature 'Delete attachments from answer', %q{
  As an owner user be able to delete an attachment
}do

  given(:user) { create(:user) }
  given(:user_non_owner) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:attachment) { create(:attachment, attachmentable: answer) }

  scenario "Authenticated user (owner of answer) can delete an Answer's attachment", js: true do
    sign_in(user)
    visit question_path(answer.question)
    within '.answers .attachments' do
      click_on 'remove'
      expect(page).to_not have_link 'spec_helper.rb'
    end
  end

  scenario "Non-authenticated user can not to delete an Answer's attachment" do
    visit question_path(question)
    within '.answers .attachments' do
      expect(page).to_not have_link 'remove'
    end
  end

  scenario "Authenticated user (not owner) can not to delete an Answer's attachment" do
    sign_in(user_non_owner)
    visit question_path(question)
    within '.answers .attachments' do
      expect(page).to_not have_link 'remove'
    end
  end
end