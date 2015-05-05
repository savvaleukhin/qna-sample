require_relative 'acceptance_helper'

feature 'User adds Social accounts to his profile', %{
  In order to sign in using different social accounts user
  be able to add social account to his profile.
} do
  given(:user) { create(:user) }
  before { sign_in(user) }

  scenario 'User add Facebook account' do
    visit edit_user_registration_path(user)
    expect(page).to have_link 'Add Facebook account'

    mock_auth_facebook
    click_on 'Add Facebook account'

    expect(page).to have_content 'Facebook account added'
  end

  scenario 'User add Twitter account' do
    visit edit_user_registration_path(user)
    expect(page).to have_link 'Add Twitter account'

    mock_auth_twitter
    click_on 'Add Twitter account'

    expect(page).to have_content 'Twitter account added'
  end
end
