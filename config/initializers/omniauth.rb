OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '157500387725769', '7d0ad29d6689c852a388434484485925'
end