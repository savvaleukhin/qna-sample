module OmniauthHelper
  def mock_auth_twitter
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      'provider' => 'twitter',
      'uid' => '123456',
      'info' => {}
    })
  end

  def mock_auth_facebook
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      'provider' => 'facebook',
      'uid' => '123456',
      'info' => {
        'email' => 'test@test.com'
      }
    })
  end
end
