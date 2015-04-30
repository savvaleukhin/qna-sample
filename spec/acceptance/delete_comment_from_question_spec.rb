require_relative 'acceptance_helper'

feature 'Delete comment from question', %q{
  Use be able to delete his comment.
}do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:comment) { create(:comment, user: author, commentable: question) }

  scenario 'Non-authenticated user can not see Delete link' do
    visit question_path(question)

    within '.comments' do
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Authenticated user (not the author) can not see Delete link' do
    sign_in(user)
    visit question_path(question)

    within '.comments' do
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Author can delete his comment', js: true, data: { type: :json } do
    sign_in(author)
    visit question_path(question)

    within '.comments' do
      click_on 'Delete'

      expect(page).to_not have_content 'My comment'
    end
  end
end