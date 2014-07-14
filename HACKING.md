#Getting Started with ClipX Development

This assumes familiarity with rails and ruby. Rest all should be documented.

Rails does most of the heavy lifting, so I will be documenting any additional gems we are using.

##Authentication
We're using the excellent devise gem for authentication, along with omniauth for any third-party ingegrations. Thirdy-party logins are not supported, and omniauth is only used to "save the access tokens" received via oauth.

##Views
We are using haml for views.

##Jobs
Resque (backed by redis) is being used for any background-jobs that we might have. To start resque work, run the following command:

    spring rake environment resque:work QUEUE=*

You can examine the current state of the resque queue by visiting /resque in the browser (Requires JS).

##Scheduled Jobs
Resque-scheduler reads the schedule from schedule.yml and automatically inserts jobs to the resque queue. The scheduled tasks should be defined in `app/tasks/cron_task.rb` but I'm using that as an invoking script for actual rake tasks, which are defined in the `lib/tasks` directory. This way, we can skip the scheduler altogether and directly run tasks using rake. For eg, to run the pocket_fetch task directly:

    spring rake fetch:pocket

An example repo for resque scheduler can be found at <https://github.com/jherrm/Resque-Scheduler-Example>. However, it defines jobs in app/jobs, which is the standard place to define resque jobs. However, a side-effect is that you can't run these jobs without using the scheduler to insert that job into rake. We instead, take a different approach and define the job in a .rake file, which can be called using rake as shown above.

To start a resque scheduler job, run the following command:

    spring rake resque:scheduler

##Tests
Default Rails unit tests. To do a quick test run, use

    spring rake test

However, to run the complete test suite (which is run on codeship), use:

    spring rake test:all

This will execute all tests, including those in our custom API libraries (which may be slow).

##Database
We provide a basic database seed, which you can import by calling `rake db:seed`, if it was not already seeded (most db commands do this already).