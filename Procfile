web: unicorn -p $PORT
scheduler: rake resque:scheduler
cron: rake environment resque:work QUEUE=cron
jobs: rake environment resque:work QUEUE=extractor,publish