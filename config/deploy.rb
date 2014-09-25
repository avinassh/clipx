require 'mina/bundler'
require 'mina/rails'
require 'mina/git'

# Configuration Settings
set :domain, 'clipx.me'
set :deploy_to, '/var/www/clipx'
set :repository, 'git@github.com:captn3m0/clipx.git'
set :branch, 'master'
set :application, "clipx"

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.

# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['log', '.env', 'tmp']

# Optional settings:
set :user, 'ubuntu'    # Username in the server to SSH to.

set_default :foreman_log,  lambda { "#{deploy_to!}/#{shared_path}/log" }

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[mkdir -p "#{deploy_to}/shared/tmp"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]
  queue! %[chmod 777 "#{deploy_to}/shared/tmp"]
end

desc "Start the application services"
task :start do
  queue %{
    echo "-----> Starting #{application} services"
    #{echo_cmd %[sudo start #{application}]}
  }
end

desc "Stop the application services"
task :stop do
  queue %{
    echo "-----> Stopping #{application} services"
    #{echo_cmd %[sudo stop #{application}]}
  }
end

desc "Restart the application services"
task :restart do
  queue %{
    echo "-----> Restarting #{application} services"
    #{echo_cmd %[sudo restart #{application}]}
  }
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

    export_cmd = "sudo foreman export upstart /etc/init -a #{application} -u #{user} -l #{foreman_log}"
    queue %{
      echo "-----> Exporting foreman procfile for #{application}"
      #{echo_cmd %[cd #{deploy_to!}/#{current_path!} ; #{export_cmd}]}
    }

    to :launch do
      queue "touch #{deploy_to}/tmp/restart.txt"
      invoke 'restart'
    end
  end
end
