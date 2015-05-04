require_relative 'acceptance_helper'

feature 'User sign in using Facebook', %q{
  User be able to sign in using outside provider Facebook.
} do
  given(:user) { create(:user, email: 'test@test.com') }

  scenario 'Registred user with Facebook authorization can sign in' do
    create(:facebook_authorization, user: user)
    visit new_user_session_path

    mock_auth_facebook
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account.'
    expect(page).to have_link 'Log out'
  end

  scenario 'Registred user without Facebook authorization can sign in' do
    user
    visit new_user_session_path

    mock_auth_facebook
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account.'
    expect(page).to have_link 'Log out'
  end

  scenario 'Guest sign up with Facebook' do
    visit new_user_session_path
    mock_auth_facebook

    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account.'
    expect(page).to have_link 'Log out'
  end
end
