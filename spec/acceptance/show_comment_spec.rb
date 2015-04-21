require_relative 'acceptance_helper'

feature 'Show list of comments', %q{
  User be able to see comments for questions
  and answers
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given(:answer) { create(:answer, question: question, user: author) }

  before do
    create(:comment, body: 'comment 1', user: author, commentable: question)
    create(:comment, body: 'comment 2', user: author, commentable: question)
    create(:comment, body: 'comment 3', user: author, commentable: answer)
    create(:comment, body: 'comment 4', user: author, commentable: answer)
  end

  context 'Authenticated author' do
    scenario 'sees the list of comments' do
      sign_in(author)
      visit question_path(question)

      expect(page).to have_content 'comment 1'
      expect(page).to have_content 'comment 2'
      expect(page).to have_content 'comment 3'
      expect(page).to have_content 'comment 4'
    end
  end

  context 'Authenticated user' do
    scenario 'sees the list of comments' do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_content 'comment 1'
      expect(page).to have_content 'comment 2'
      expect(page).to have_content 'comment 3'
      expect(page).to have_content 'comment 4'
    end
  end

  context 'Non-authenticated user' do
    scenario 'sees the list of comments' do
      visit question_path(question)

      expect(page).to have_content 'comment 1'
      expect(page).to have_content 'comment 2'
      expect(page).to have_content 'comment 3'
      expect(page).to have_content 'comment 4'
    end
  end
end