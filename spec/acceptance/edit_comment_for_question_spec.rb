require_relative 'acceptance_helper'

feature 'Edit comment for question', %q{
  Use be able to edit his comment.
}do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:comment) { create(:comment, user: author, commentable: question) }

  scenario 'Non-authenticated user can not see Edit link' do
    visit question_path(question)

    within '.comments' do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Authenticated user (not the author) can not see Edit link' do
    sign_in(user)
    visit question_path(question)

    within '.comments' do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Author can edit his comment', js: true, data: { type: :json } do
    sign_in(author)
    visit question_path(question)

    within '.comments' do
      click_on 'Edit'
      fill_in 'comment_body', with: 'Modified comment'
      click_on 'Save'

      expect(page).to_not have_content 'Modified comment'
      expect(page).to_not have_selector 'textarea'
    end
  end
end