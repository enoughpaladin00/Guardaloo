OmniAuth.config.allowed_request_methods = [:get, :post]

Rails.application.config.middleware.use OmniAuth::Builder do

  provider :google_oauth2,
            ENV['GOOGLE_CLIENT_ID'],
            ENV['GOOGLE_CLIENT_SECRET'],
            {
            callback_path: '/auth/google_oauth2/callback',
            scope: 'email,profile',
            prompt: 'select_account',
            image_aspect_ratio: 'square',
            image_size: 50
            }

  provider :facebook,
            ENV['FACEBOOK_APP_ID'],
            ENV['FACEBOOK_APP_SECRET'],
            {
              scope: 'email',
              info_fields: 'email,first_name,last_name',
              callback_path: '/auth/facebook/callback',
              display: 'popup'
            }

end
