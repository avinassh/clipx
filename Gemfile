source 'https://rubygems.org'
ruby '2.0.0'
gem 'rails', '4.1.4'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'pg'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'bootstrap-sass'
gem 'devise'  # Handles user authentication
gem 'haml-rails'
gem 'high_voltage'  # Static Pages like about
gem "default_value_for", "~> 3.0.0" # Specify default values for AR in migrations

# New relic to monitor app performance
# Used in all environments except test
gem 'newrelic_rpm'

# Evernote Util class requires these
gem 'tidy_ffi' # html to valid xhtml
gem 'loofah' # HTML sanitization & enml conversions
gem 'libxml-ruby' # XML validation using DTD

# Omniauth strategeies
gem 'omniauth-pocket'
gem 'omniauth-evernote'
gem 'omniauth-twitter'

# API connections
gem 'getpocket'
gem 'evernote_oauth'
gem 'readability_parser'
gem 'twitter'

# Resque related
gem "resque"  # Background Jobs
gem "resque-scheduler"  # Schedule background jobs
gem 'resque-web', require: 'resque_web' # Web UI for our resque jobs

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_20]
  gem 'html2haml'
  gem 'quiet_assets'
  gem 'rails_layout'
  # Faster environment loads
  gem 'spring'
end

# These are not installed on the production server
group :test do
  # Simple coverage reports for our tests
  gem 'simplecov'
  # This is for stubbing and mocking support in tests
  gem 'mocha'
  # CodeClimate
  gem "codeclimate-test-reporter"
end

group :production do
  # This is our web server for production, recommended by both heroku and github
  gem 'unicorn'
  # Redirects all rails output to stdout, recommended by heroku
  gem 'rails_12factor'
end