require_relative 'acceptance_helper'

feature(
  'Create comment for an answer',
  'User be able to add comment to answer.') do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(answer.question)
    end

    scenario 'Creates comment', js: true, data: { type: :json } do
      within '.answers' do
        click_on 'add comment'
        fill_in 'comment_body', with: 'My comment'
        click_on 'Add'

        expect(page).to have_content 'My comment'
      end
    end

    scenario 'Tries to create invalid comment', js: true, data: { type: :json } do
      within '.answers' do
        click_on 'add comment'
        fill_in 'comment_body', with: nil
        click_on 'Add'
      end

      expect(page).to have_content "body can't be blank"
    end
  end

  context 'Non-authenticated user' do
    scenario 'Can not to see link to create comment' do
      expect(page).to_not have_link 'add comment'
    end
  end
end
