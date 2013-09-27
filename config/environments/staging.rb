Caball::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Authenitaction for staging environment
  # config.middleware.insert_after(::Rack::Lock, "::Rack::Auth::Basic", "staging") do |u, p|
  #   [u, p] == ['admin', 'Caball666']
  # end

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  config.log_level = :info

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  config.action_controller.asset_host = "d1cujs8uckytjb.cloudfront.net"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w( admin/admin.css admin/*.js )
  config.assets.precompile += %w( conversations/new.css users/users_manifest.js dashboard/dashboard.css dashboard/dashboard_manifest.js users/users.js signup.css signin.css
                                events_manifest.js events/manifest.css events/event_index.css events/events_manifest.js home_page.css 
                                users/user_index.css application.js 
                                projects/projects_manifest.js projects/manifest.css users/user_search.js projects/project_index.css 
                                static_pages/our_story.css 
                                users/users_manifest.js users/manifest.css users/show.css contact.js glossary.js static_pages/labs.css)
  config.assets.precompile += %w( chosen )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false
    
  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

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
  config.action_mailer.default_url_options = { :host => 'mysterious-brook-4528.herokuapp.com' }

  # show SQL activity and params in the logs.
  config.logger = Logger.new(STDOUT)
end