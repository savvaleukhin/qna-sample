require_relative 'acceptance_helper'

feature 'Vote for answers', %q{
  In order to illustrate helpfulness of answer
  User as non author can vote for the answer
}do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given(:answer) { create(:answer, question: question, user: author) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(answer.question)
    end

    scenario 'can vote UP', js: true do
      within '.answers' do
        click_on 'up'
      end

      within "#answer-#{answer.id}-votes" do
        expect(page).to have_content '1'
      end
    end

    scenario 'can vote DOWN', js: true do
      within '.answers' do
        click_on 'down'
      end

      within "#answer-#{answer.id}-votes" do
        expect(page).to have_content '-1'
      end
    end

    scenario 'can unvote', js: true do
      within '.answers' do
        click_on 'up'
        click_on 'unvote'
      end

      within "#answer-#{answer.id}-votes" do
        expect(page).to have_content '0'
      end
    end
  end

  scenario 'Author can not to vote for his question' do
    sign_in(author)
    visit question_path(answer.question)

    within '.answers' do
      expect(page).to_not have_link 'up'
      expect(page).to_not have_link 'down'
      expect(page).to_not have_link 'unvote'
    end
  end

  scenario 'Non-authenticated user can not to vote for a question' do
    visit question_path(answer.question)

    within '.answers' do
      expect(page).to_not have_link 'up'
      expect(page).to_not have_link 'down'
      expect(page).to_not have_link 'unvote'
    end
  end
end