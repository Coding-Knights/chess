Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['2712475462176654'], ENV['FACEBOOK_APP_SECRET'],
       scope: 'email', display: 'popup'

end