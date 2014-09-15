source 'https://rubygems.org'
ruby '2.0.0'
gem 'rails', '4.1.4'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
# Load env variables from .env file
gem 'dotenv-rails', :groups => [:production]
gem 'pg'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'bootstrap-sass'
gem 'devise'  # Handles user authentication
gem 'haml-rails'
gem 'high_voltage'  # Static Pages like about
gem "default_value_for", "~> 3.0.0" # Specify default values for AR in migrations

gem "bourbon"
gem "neat"
gem 'font-awesome-sass'

gem 'sanitize' # HTML sanitization before displaying article content
# New relic to monitor app performance
# Used in all environments except test
gem 'newrelic_rpm'
gem 'foreman' # Single task runner for all our processes
gem 'render_anywhere' # Render print view in jobs
# Evernote Util class requires these
gem 'tidy_ffi' # html to valid xhtml
gem 'loofah' # HTML sanitization & enml conversions
gem 'libxml-ruby' # XML validation using DTD

# Omniauth strategeies
gem 'omniauth-pocket'
gem 'omniauth-evernote'
gem 'omniauth-twitter'
gem 'omniauth-github'
gem 'omniauth-google-oauth2'
gem 'omniauth-dropbox-oauth2'

# API connections
gem 'getpocket'
gem 'evernote_oauth'
gem 'readability_parser'
gem 'twitter'
gem 'octokit'
gem 'github-markup'
gem 'simple_google_drive' # Used for creating a spreadsheet
gem 'google_drive' # For writing to a spreadsheet
gem 'dropbox-sdk'

# Resque related
gem "resque"  # Background Jobs
gem "resque-scheduler"  # Schedule background jobs
gem 'resque-web', require: 'resque_web' # Web UI for our resque jobs

# Search related
gem 'searchkick'

# Used to render github readmes
gem 'redcarpet'
gem 'RedCloth'
gem 'rdoc', '3.6.1'
gem 'org-ruby'
gem 'creole'
gem 'wikicloth'
gem 'asciidoctor'

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
  # Dropbox to upload coverage report to
  gem 'dbox'
  # mina to do deploys
  gem 'mina'
end

group :production do
  # This is our web server for production, recommended by both heroku and github
  gem 'unicorn'
  # Redirects all rails output to stdout, recommended by heroku
  gem 'rails_12factor'
  # This is for execjs needing a js runtime
  gem "therubyracer"
end