namespace :resque do
  task :setup do
    require 'resque'
    require 'resque-scheduler'

    # you probably already have this somewhere
    config = YAML.load_file(Rails.root.join('config', 'resque.yml'))
    schedule = YAML.load_file(Rails.root.join('config', 'schedule.yml'))

    # configure redis connection
    Resque.redis = config[Rails.env]

    # configure the schedule
    Resque.schedule = schedule

    # set a custom namespace for redis (optional)
    Resque.redis.namespace = "resque:clipx"
    #This is duplicated in config/initializers/resque.rb because the setup task doesn't run when queing a job
    #and initializers aren't run when running the scheduler rake task
  end
end