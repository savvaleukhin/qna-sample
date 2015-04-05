require_relative 'acceptance_helper'

feature 'Vote for questions', %q{
  In order to illustrate helpfulness of question
  User as non author can vote for the question
}do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can vote UP', js: true do
      within '.question' do
        click_on 'up'
      end

      within '.question_votes' do
        expect(page).to have_content '1'
      end
    end

    scenario 'can vote DOWN', js: true do
      within '.question' do
        click_on 'down'
      end

      within '.question_votes' do
        expect(page).to have_content '-1'
      end
    end

    scenario 'can unvote', js: true do
      within '.question' do
        click_on 'up'
        click_on 'unvote'
      end

      within '.question_votes' do
        expect(page).to have_content '0'
      end
    end
  end

  scenario 'Author can not to vote for his question' do
    sign_in(author)
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'up'
      expect(page).to_not have_link 'down'
      expect(page).to_not have_link 'unvote'
    end
  end

  scenario 'Non-authenticated user can not to vote for a question' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'up'
      expect(page).to_not have_link 'down'
      expect(page).to_not have_link 'unvote'
    end
  end
end