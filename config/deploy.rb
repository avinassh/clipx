require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'mina/foreman'

# Configuration Settings
set :domain, 'clipx.captnemo.in'
set :deploy_to, '/var/www/clipx'
set :repository, 'git@github.com:captn3m0/clipx.git'
set :branch, 'deploy'
set :application, "clipx"

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.

# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['log', '.env']

# Optional settings:
set :user, 'ubuntu'    # Username in the server to SSH to.
set :rvm_path, '/usr/local/rvm/scripts/rvm'

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # version-patch@gemset
  invoke :'rvm:use[ruby-2.0.0-p481@clipx]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'foreman:export'

    to :launch do
      queue "touch #{deploy_to}/tmp/restart.txt"
      invoke 'foreman:restart'
    end
  end
end