source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'

# Ok lets try out the heroku business
gem 'heroku'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'

  # Twitter Boostrap and Upgrade dependencies
  gem 'therubyracer'
  gem 'less-rails'
  gem 'twitter-bootstrap-rails'
  
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'
gem 'cap_bootstrap', github: 'benrs44/cap_bootstrap'

# To use debugger
# gem 'debugger'

gem "rspec-rails", :group => [:test, :development]
group :test do
  gem "factory_girl_rails"
  gem "capybara"
  gem "guard-rspec"
  gem 'rb-fsevent', '~> 0.9.1'
end

#Image Uploader
gem 'carrierwave'

#Image Processor
gem "rmagick"

#Video Processor
gem 'video_info'
gem 'hpricot'

#Authenitcation
gem 'omniauth-facebook'

#Messaging
gem 'mailboxer', github: 'rralston/mailboxer'
gem 'haml-rails'
gem 'simple_form'

#Gelocation
gem 'geocoder'

#Search
gem 'ransack'

# For easily making nouns possessive
gem 'possessive'

#Pagination
gem "kaminari"

#Web App Monitoring
gem 'newrelic_rpm'

#FB Style Newsfeeds
gem 'public_activity'

# Heroku CDN Link to AWS
gem "asset_sync"

# Carrier Wave link to AWS S#
gem 'fog'

# Performance Testing
gem 'rack-mini-profiler'