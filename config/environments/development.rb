Caball::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb
  
  # config.middleware.use Rack::Auth::Basic, "Beta Access" do |username, password|
  #   'secret' == password
  # end
  
  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # change to false to prevent email from being sent during development
  config.action_mailer.perform_deliveries = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = false
  
  # Change mail delvery to either :smtp, :sendmail, :file, :test
  config.action_mailer.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
                     :address        => "smtp.gmail.com",
                     :port           => 587,
                     :authentication => :plain,
                     :user_name      => "notifications@filmzu.com",
                     :password       => "TheFilmzu1912",
                     :openssl_verify_mode  => 'none'
   }
  
  # Change when Push to the Website or will Error out
  config.action_mailer.default_url_options = { :host => 'development.filmzu.com' }
  # config.action_mailer.default_url_options = { :host => 'filmzu-dev-env-cpbt693qtg.elasticbeanstalk.com' }
  # config.action_mailer.default_url_options = { :host => 'filmzu-4mapu5m2zx.elasticbeanstalk.com' }
end
