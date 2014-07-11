#Getting Started with ClipX Development

This assumes familiarity with rails and ruby. Rest all should be documented.

Rails does most of the heavy lifting, so I will be documenting any additional gems we are using.

##Authentication
We're using the excellent devise gem for authentication, along with omniauth for any third-party ingegrations. Thirdy-party logins are not supported, and omniauth is only used to "save the access tokens" received via oauth.

##Views
We are using haml for views.

##Jobs
Resque (backed by redis) is being used for any background-jobs that we might have

##Scheduled Jobs
Resque-scheduler reads the schedule from schedule.yml and automatically inserts jobs to the resque queue. The scheduled tasks should be defined in `app/tasks/cron_task.rb` but I'm using that as an invoking script for actual rake tasks, which are defined in the `lib/tasks` directory. This way, we can skip the scheduler altogether and directly run tasks using rake. For eg, to run the pocket_fetch task directly:

    spring rake fetch:pocket