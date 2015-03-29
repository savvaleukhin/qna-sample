require_relative 'acceptance_helper'

feature 'Add files to answers', %q{
  In order to illustrate my answer
  As an answer's owner
  I'd like to be able to attach files
}do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds a file when he is creating an answer', js: true do
    fill_in 'Your answer', with: 'My answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'User adds several files when he is creating an answer', js: true do
    click_on 'New attachment'
    fields = page.all('input[type="file"]')

    fill_in 'Your answer', with: 'My answer'
    fields[0].set "#{Rails.root}/spec/spec_helper.rb"
    fields[1].set "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end
end