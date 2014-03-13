Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both thread web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Enable Rack::Cache to put a simple HTTP cache in front of your application
  # Add `rack-cache` to your Gemfile before enabling this.
  # For large-scale production use, consider using a caching reverse proxy like nginx, varnish or squid.
  # config.action_dispatch.rack_cache = true

  # Disable Rails's static asset server (Apache or nginx will already do this).
  config.serve_static_assets = false

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Version of your assets, change this if you want to expire all your assets.
  config.assets.version = '1.0'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Set to :debug to see everything in the log.
  config.log_level = :info

  # Prepend all log lines with the following tags.
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups.
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets.
  # application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
  # config.assets.precompile += %w( search.js )

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Disable automatic flushing of the log to improve performance.
  # config.autoflush_log = false

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  config.action_controller.asset_host = "d1w6ekkvcymcvm.cloudfront.net"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)

  config.assets.precompile += %w(application.js bootstrap-select.js bootstrap-slider.js bootstrap.js caball.js.coffee controllers/filmmakers_page.js mixins/pagination_mixin.js models/filmmaker.js models/person.js pages.js router.js routes/application.js routes/filmmakers.js routes/filmmakers_page.js routes/person.js store.js templates/filmmaker.hjs templates/filmmakers.hjs templates/filmmakers_page.hjs templates/global-loading.hjs templates/person.hjs application.css.scss bootstrap-select.css.scss bootstrap.css.scss font-awesome.css.scss font.css.scss grid.css.scss home_page.css.scss ionicons.css.scss navigation.css.scss pages.css.scss)


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
  config.action_mailer.default_url_options = { :host => 'filmzu.com' }
end

#Caball::Application.configure do
#  # Settings specified here will take precedence over those in config/application.rb
#
#  # config.middleware.use Rack::Auth::Basic, "Beta Access" do |username, password|
#  #   'secret' == password
#  # end
#
#  # Code is not reloaded between requests
#  config.cache_classes = true
#
#  # Full error reports are disabled and caching is turned on
#  config.consider_all_requests_local       = false
#  config.action_controller.perform_caching = true
#
#  # Disable Rails's static asset server (Apache or nginx will already do this)
#  config.serve_static_assets = false
#
#  # Compress JavaScripts and CSS
#  config.assets.compress = true
#
#  # Don't fallback to assets pipeline if a precompiled asset is missed
#  config.assets.compile = false
#
#  # Generate digests for assets URLs
#  config.assets.digest = true
#
#  # Defaults to nil and saved in location specified by config.assets.prefix
#  # config.assets.manifest = YOUR_PATH
#
#  # Specifies the header that your server uses for sending files
#  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
#  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx
#
#  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
#  # config.force_ssl = true
#
#  # See everything in the log (default is :info)
#  # config.log_level = :debug
#
#  # Prepend all log lines with the following tags
#  # config.log_tags = [ :subdomain, :uuid ]
#
#  # Use a different logger for distributed setups
#  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)
#
#  # Use a different cache store in production
#  # config.cache_store = :mem_cache_store
#
#  # Enable serving of images, stylesheets, and JavaScripts from an asset server
#  # config.action_controller.asset_host = "https://#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com"
#  # Development Cloudfront
#  # config.action_controller.asset_host = "d1stg2u3ujiznp.cloudfront.net"
#  # Production Cloudfront
#  config.action_controller.asset_host = "d1w6ekkvcymcvm.cloudfront.net"
#
#  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
#
#  config.assets.precompile += %w( admin/admin.css admin/*.js conversations/new.css users/users_manifest.js dashboard/dashboard.css dashboard/dashboard_manifest.js users/users.js signup.css signin.css
#                                events_manifest.js events/manifest.css events/event_index.css events/events_manifest.js home_page.css
#                                users/user_index.css application.js
#                                projects/projects_manifest.js projects/manifest.css users/user_search.js projects/project_index.css
#                                static_pages/our_story.css
#                                users/users_manifest.js users/manifest.css users/show.css contact.js glossary.js static_pages/labs.css dashboard/introjs.css dashboard/intro.js)
#
#  # Disable delivery errors, bad email addresses will be ignored
#  # config.action_mailer.raise_delivery_errors = false
#
#  # Enable threaded mode
#  # config.threadsafe!
#
#  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
#  # the I18n.default_locale when a translation can not be found)
#  config.i18n.fallbacks = true
#
#  # Send deprecation notices to registered listeners
#  config.active_support.deprecation = :notify
#
#  # Log the query plan for queries taking more than this (works
#  # with SQLite, MySQL, and PostgreSQL)
#  # config.active_record.auto_explain_threshold_in_seconds = 0.5
#
#  # Change mail delvery to either :smtp, :sendmail, :file, :test
#  config.action_mailer.delivery_method = :smtp
#  ActionMailer::Base.smtp_settings = {
#                     :address        => "smtp.gmail.com",
#                     :port           => 587,
#                     :authentication => :plain,
#                     :user_name      => "notifications@filmzu.com",
#                     :password       => "TheFilmzu1912",
#                     :openssl_verify_mode  => 'none'
#   }
#
#  # Change when Push to the Website or will Error out
#  config.action_mailer.default_url_options = { :host => 'filmzu.com' }
#  # config.action_mailer.default_url_options = { :host => 'development.filmzu.com' }
#  # config.action_mailer.default_url_options = { :host => 'filmzu-dev-env-cpbt693qtg.elasticbeanstalk.com' }
#  # config.action_mailer.default_url_options = { :host => 'filmzu-4mapu5m2zx.elasticbeanstalk.com' }
#end
