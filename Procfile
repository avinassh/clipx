scheduler: bundle exec rake resque:scheduler
cron: bundle exec rake environment resque:work QUEUE=cron
jobs: bundle exec rake environment resque:work QUEUE=extractor,publish
fetch: bundle exec rake environment resque:work QUEUE=fetch
export: bundle exec rake environment resque:work QUEUE=export
import: bundle exec rake environment resque:work QUEUE=import
