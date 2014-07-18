web: unicorn -c config/unicorn.rb -p $PORT
scheduler: rake resque:scheduler
cron: rake environment resque:work QUEUE=cron
jobs: rake environment resque:work QUEUE=extractor,publish
