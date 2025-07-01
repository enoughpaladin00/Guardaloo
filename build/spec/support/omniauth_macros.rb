module OmniauthMacros
  def mock_auth_google
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      provider: 'google_oauth2',
      uid: '1234567890',
      info: {
        email: 'testuser@example.com',
        first_name: 'Test',
        last_name: 'User',
        name: 'Test User',
        image: 'https://example.com/avatar.jpg'
      },
      credentials: {
        token: 'mock_token',
        refresh_token: 'mock_refresh_token'
      }
    )
  end

  def mock_auth_failure
    OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
  end
end
