#Clipx

Build Status: [![Build Status](https://www.codeship.io/projects/043e24b0-ed41-0131-5536-2e128a408349/status?branch=master)](https://www.codeship.io/projects/26657)

ClipX is a rails application for content syndication. More details about the application can be found in Architecture.md. Setup is just `bundle install --without production`, followed by `foreman start -f Procfile.dev` to start all the required tasks, including the web server. More detailed development instructions are in `HACKING.md`.

#Boilerplate

This application was generated with the [rails_apps_composer](https://github.com/RailsApps/rails_apps_composer) gem
provided by the [RailsApps Project](http://railsapps.github.io/).

##Preferences
- Template Engine: Haml
- Testing Framework: Test::Unit
- Front-end Framework: Bourbon+Neat+Bitters
- Authentication: Devise
- Job Queue System: Resque
- Cron System: Resque-Scheduler
- Database: postgresql

##Development
- Web Server: Webrick

##Production
- Web Server: Apache + Passenger

##Third party integrations
- Code Coverage is provided via simplecov and code climate.
- Application performance is monitored via new relic.
