source 'https://rubygems.org'
ruby '2.0.0'
gem 'rails', '4.1.4'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'bootstrap-sass'
gem 'devise'  # Handles user authentication
gem 'haml-rails'
gem 'high_voltage'  # Static Pages like about
gem "default_value_for", "~> 3.0.0" # Specify default values for AR in migrations

# Evernote Util class requires these
gem 'tidy_ffi' # html to valid xhtml
gem 'loofah' # HTML sanitization & enml conversions
gem 'libxml-ruby' # XML validation using DTD

# Omniauth strategeies
gem 'omniauth-pocket' # Connect a pocket account
gem 'omniauth-evernote' # Connect a evernote account

# API connections
gem 'getpocket' # Talk to the pocket API
gem 'evernote_oauth' # Talk to the evernote API
# Fork of the readability parser API
# with updated dependencies
gem 'readability_parser', :git => 'https://github.com/captn3m0/readability_parser.git'

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
  # Sqlite is only loaded in development
  gem 'sqlite3'
  # This is for stubbing and mocking support in tests
  gem 'mocha'
  # Faster environment loads
  gem 'spring'
end

group :production do
  # This is our web server for production, recommended by both heroku and github
  gem 'unicorn'
  # Redirects all rails output to stdout, recommended by heroku
  gem 'rails_12factor'
  # Sqlite3 causes issues with dokku due to heroku-buildpacks not supporting it
  gem 'pg'
end
