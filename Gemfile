source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'

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

gem 'awesome_print'

group :test, :development do
  gem 'rspec-rails', '>= 2.0.1'
  gem "capybara-webkit"
  gem 'capybara'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'ci_reporter'
  gem "factory_girl_rails", "~> 4.0"
  # DRb server RSpec
  gem "spork-rails"
  # To use debugger
  gem 'debugger'
end

group :test do
  gem "guard-rspec"
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'database_cleaner'
  gem 'fuubar'
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
gem 'will_paginate', '~> 3.0'

#Web App Monitoring
gem 'newrelic_rpm'

#FB Style Newsfeeds
gem 'public_activity'

# Heroku CDN Link to AWS
gem "asset_sync"

# Carrier Wave link to AWS S#
gem 'fog'
gem 'cancan'

# client side validtions
gem 'client_side_validations'