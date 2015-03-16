require 'rails_helper'

feature 'Edit question', %q{
  An authenticated user be able to change his question
}do

  scenario 'Non-authenticated user tries to edit a question' do
  end

  scenario 'Authenticated user (not the owner) tries to edit a question' do
  end

  scenario 'Authenticated user (owner) edits a question' do
  end
end