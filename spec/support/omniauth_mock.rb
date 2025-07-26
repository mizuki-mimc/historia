OmniAuth.config.test_mode = true

OmniAuth.config.on_failure = Proc.new do |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
end

def mock_auth_for(user)
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: 'google_oauth2',
    uid: user.uid,
    info: {
      name: user.name,
      email: user.email,
      image: 'http://example.com/mock_image.jpg'
    },
    credentials: {
      token: 'mock_token',
      refresh_token: 'mock_refresh_token',
      expires_at: 1.hour.from_now.to_i
    }
  })
end

RSpec.configure do |config|
  config.after(:each, type: :system) do
    OmniAuth.config.mock_auth[:google_oauth2] = nil
  end
end
