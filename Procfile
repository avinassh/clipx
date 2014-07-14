web: unicorn -p $PORT -c config/unicorn.rb
scheduler: rake resque:scheduler
cron: rake environment resque:work QUEUE=cron
jobs: rake environment resque:work QUEUE=extractor,publish