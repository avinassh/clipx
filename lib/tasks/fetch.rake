#This task namespace holds all the fetching tasks
#which poll services to get any new updates
namespace :fetch do
  desc "Fetch updates from pocket for all connected pocket accounts"
  task :pocket do 
    require 'pocket_api'
    PocketAccount.find_each do |account|

      #Save the time when we are making the request
      current_time = Time.now.to_i

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
      #Update the account in our db
      account.update_attribute 'last_fetched', current_time

      #Iterate over the result and insert to db
      result.each do |article|
        puts article['resolved_url']
        #TODO: Insert each item to database
        #ActiveRecord::Base.transaction do
        #  1000.times { Model.create(options) }
        #end
      end
    end
  end
end