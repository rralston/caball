OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
# Rupe
#  provider :facebook, '157500387725769', '7d0ad29d6689c852a388434484485925'
# Max
  # provider :facebook, '547686081928278', '6d797e8938754d5d5dc169297d6f96ba'
# Max - Heroku
  provider :facebook, '424186127674629', '93be6297e519582ef42fcb0fb42312d4'
end
