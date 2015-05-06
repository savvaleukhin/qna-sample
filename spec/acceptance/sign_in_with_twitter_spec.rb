require_relative 'acceptance_helper'

feature 'User sign in using Twitter', %q{
  User be able to sign in using outside provider Twitter.
} do
  given(:user) { create(:user, email: 'test@test.com') }

  context 'Valid attributes' do
    scenario 'Registred user with twitter authorization can sign in' do
      create(:twitter_authorization, user: user)
      visit new_user_session_path

      mock_auth_twitter
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      expect(page).to have_link 'Log out'
    end

    scenario 'Registred user without twitter authorization can not to sign in' do
      user
      visit new_user_session_path

      mock_auth_twitter
      click_on 'Sign in with Twitter'
      expect(current_path).to eq new_omniauth_registration_path

      fill_in 'email', with: 'test@test.com'
      click_on 'Save'
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'You already have an accaunt for this email.
        You need to log in and add social accounts to you profile.'
    end

    scenario 'Guest signs up with twitter' do
      visit new_user_session_path
      mock_auth_twitter

      click_on 'Sign in with Twitter'
      fill_in 'email', with: 'test@test.com'
      click_on 'Save'

      expect(page).to have_content 'Successfully signed up with Twitter account.'
      expect(page).to have_link 'Log out'
    end
  end

  context 'Invalid attributes' do
    scenario 'Guest can not to sign up with invalid email' do
      visit new_user_session_path
      mock_auth_twitter

      click_on 'Sign in with Twitter'
      fill_in 'email', with: nil
      click_on 'Save'

      expect(page).to have_content "Email can't be blank"
      expect(current_path).to eq omniauth_registrations_path
    end
  end
end
