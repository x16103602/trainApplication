OmniAuth.config.logger = Rails.logger
Rails.application.config.middleware.use OmniAuth::Builder do
provider :twitter, Rails.application.secrets.API_TWITTER_KEY, Rails.application.secrets.API_TWITTER_SECRET
provider :facebook, Rails.application.secrets.API_FB_KEY, Rails.application.secrets.API_FB_APP_SECRET, {:provider_ignores_state => true}
provider :google_oauth2, Rails.application.secrets.API_GOOGLE_KEY, Rails.application.secrets.API_GOOGLE_SECRET, {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end

#Rails.application.config.middleware.use OmniAuth::Builder do
#  provider :facebook, "133380967242125", "d84aef89614415d77d4d18752a6b14b7", {:provider_ignores_state => true}
#end
