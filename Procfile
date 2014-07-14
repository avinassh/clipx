web: bundle exec unicorn -p $PORT
scheduler: bundle exec rake resque:scheduler
cron: bundle exec rake environment resque:work QUEUE=cron
jobs: bundle exec rake environment resque:work QUEUE=extractor,publish