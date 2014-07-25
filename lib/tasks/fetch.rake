#
# This task namespace holds all the fetching tasks
# which poll services to get any new updates
#
namespace :fetch do
  desc "Fetch updates from pocket for all connected pocket accounts"
  task :pocket do
    PocketAccount.find_each do |account|
      Resque.enqueue FetchPocketJob, account.id
    end
  end
  desc "Fetch updates from pocket for all connected twitter accounts"
  task :twitter do
    TwitterAccount.find_each do |account|
      Resque.enqueue FetchTwitterJob, account.id
    end
  end
end