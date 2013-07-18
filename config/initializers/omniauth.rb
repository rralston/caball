OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  # Rupe
  case ENV['RAILS_ENV']
  when "development"
    provider :facebook, '280010852092039', 'abe980ce8a22eaf16208aca8e15c180e'
  when "staging"
    provider :facebook, '387784777988620', 'e89f3abd1f30cef5b61c541afe2ece5a'
  when "production"
    provider :facebook, '424186127674629', '93be6297e519582ef42fcb0fb42312d4'
  end
  # mysterious-brook-4528 Heroku
  # provider :facebook, '157500387725769', 'c83875c4189828808e4cf948b43e12d5'
  # Max
  # provider :facebook, '547686081928278', '6d797e8938754d5d5dc169297d6f96ba'
  # Max - Heroku
  # provider :facebook, '424186127674629', '93be6297e519582ef42fcb0fb42312d4'
end