#Getting Started with ClipX Development

This assumes familiarity with rails and ruby. Rest all should be documented.

Rails does most of the heavy lifting, so I will be documenting any additional gems we are using.


##Quick Start
Run the following commands to get started with clipx development:

    # Install all development gems
    bundle install --without production
    # Start web server and all resque tasks, including scheduler
    foreman start -f Procfile.dev
    # Run all tests
    spring rake test:all
    # Run only the common tests
    spring rake test

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
We provide a basic database seed, which you can import by calling `rake db:seed`, if it was not already seeded (most db commands do this already). We have shifted to using pg in development as well. Instructions to setup database:

```sh
sudo apt-get install postgresql libpq-dev phppgadmin pgadmin3
# Now update /etc/postgresql/9.3/main/pg_hba.conf
# to read
# local all all md5
# instead of
# local all all peer
# to enable password auth
sudo su postgres -c psql
# Rest of the commands in the psql shell
create user clipx  with password 'clipx_db';
create database clipx_development;
create database clipx_test;
grant all privileges on database clipx_development to clipx;
grant all privileges on database clipx_test to clipx;
\q
sudo service postgresql restart
```

##Design Decisions
- Test::Unit instead of rspec because we are not adept enough in rails and should start with the basics.
- Fixtures instead of factorygirl because we are still learning rails
- Bourbon+Neat because we both hate twbs/bootstrap and wanted something that gives a cleaner syntax
- Rails+Resque instead of a SOA because I wanted to avoid over-complication stuff when it wasn't needed.
- CodeShip instead of Travis because its free for private repos
- GitHub instead of BitBucket (even though its free) because its just far better.