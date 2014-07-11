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
  end
end