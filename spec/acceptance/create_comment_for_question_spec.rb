require_relative 'acceptance_helper'

feature 'Create comment for question', %q{
  User be able to add comment to question.
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Creates comment' do
      within '.question' do
        click_on 'add comment'
        fill_in 'Your comment', with: 'My comment'
        click_on 'Add'

        expect(page).to have_content 'My comment'
      end
    end

    scenario 'Tries to create invalid comment' do
      within '.question' do
        click_on 'add comment'
        fill_in 'Your comment', with: nil
        click_on 'Add'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'Can not to see link to create comment' do
    expect(page).to_not have_link 'add comment'
  end
end
