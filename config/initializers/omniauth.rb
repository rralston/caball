OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '547686081928278', '6d797e8938754d5d5dc169297d6f96ba'
end
