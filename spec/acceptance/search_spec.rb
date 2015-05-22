require_relative 'acceptance_helper'

feature 'Search', %q(
  In order to find interesting question
  user be able to use search mechanism.
) do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question_list, 2, user: user, body: 'Question') }
  given!(:question) { create(:question, user: user, title: 'Full Question', body: 'the body') }
  given!(:answer) { create(:answer, question: question, user: user, body: 'best answer') }
  given!(:comment) { create(:comment, commentable: question, user: user, body: 'first comment') }

  scenario 'User searches a question globally', js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'query', with: 'Question'
      click_on 'Search'

      expect(current_path).to eq search_path
      expect(page).to have_content 'Question'
      within '.results' do
        expect(page).to have_selector('div', count: 3)
      end
    end
  end

  scenario 'User searches a question by title or body', js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'query', with: 'the body'
      select('questions', from: 'condition')
      click_on 'Search'

      expect(current_path).to eq search_path
      expect(page).to have_content 'Full Question'
      within '.results' do
        expect(page).to have_selector('div', count: 1)
      end
    end
  end

  scenario 'User searches a question by answer', js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'query', with: 'best answer'
      select('answers', from: 'condition')
      click_on 'Search'

      expect(current_path).to eq search_path
      expect(page).to have_content 'Full Question'
      within '.results' do
        expect(page).to have_selector('div', count: 1)
      end
    end
  end

  scenario 'User searches a question by comment', js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'query', with: 'first comment'
      select('comments', from: 'condition')
      click_on 'Search'

      expect(current_path).to eq search_path
      expect(page).to have_content 'Full Question'
      within '.results' do
        expect(page).to have_selector('div', count: 1)
      end
    end
  end

  scenario 'User searches a question by users email', js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'query', with: question.user.email
      select('users', from: 'condition')
      click_on 'Search'

      expect(current_path).to eq search_path
      expect(page).to have_content 'Full Question'
      expect(page).to have_content 'Question #'
      within '.results' do
        expect(page).to have_selector('div', count: 3)
      end
    end
  end
end
