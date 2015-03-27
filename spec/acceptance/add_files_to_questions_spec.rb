require_relative 'acceptance_helper'

feature 'Add files to questions', %q{
  In order to illustrate my questions
  As an question's owner
  I'd like to be able to attach files
}do

  given(:user) { create(:user) }

  background do
    sign_in user
    visit new_question_path
  end

  scenario 'User adds a file when he is asking a question.' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Body of test question'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Save'

    expect(page).to have_content 'spec_helper.rb'
  end
end