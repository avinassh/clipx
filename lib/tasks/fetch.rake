#This task namespace holds all the fetching tasks
#which poll services to get any new updates
namespace :fetch do
  desc "Fetch updates from pocket for all connected pocket accounts"
  task :pocket do 
    require 'pocket_api'
    PocketAccount.find_each do |account|

      #Save the time when we are making the request
      current_time = Time.now.to_i
      user = account.user
      #Make the reqest
      PocketApi.configure(:client_key=> Rails.application.secrets.pocket_key, :access_token => account.token)
      result = PocketApi.retrieve(
        :state => 'all',
        :contentType => 'article',
        :sort => 'newest',
        :detailType => 'simple',
        :since => account.last_fetched,
        :count=>10
      )

      #Iterate over the result and insert to db
      result.each do |key, article|
        puts article['resolved_url']
        puts article['tags'] || "No tags"
        ActiveRecord::Base.transaction do
          article = user.article_create(
            :url=>article['resolved_url'],
            :title=>article['given_title'],
            :provider=>'pocket',
            #TODO: Insert tags which we get from pocket as well
            #TODO: Check for any images that pocket gave us
            :content => article['excerpt'],
          )
        end
        Resque.enqueue ReadabilityJob, article.id unless article.id.nil?
        #TODO: Throw error if article save failed, or if resque enqueue failed
      end

      puts "No articles fetched" if result.size == 0
      #Update the account in our db
      account.update_attribute :last_fetched, current_time
    end
  end
end