require 'pocket_api'
class ImportJob
  @queue = :import
  # This job imports things for non-publisher accounts
  def self.perform(user_id, account_class_name, account_id)
    user = User.find(user_id)

    # Figure out the provider name from class name
    klass = account_class_name.constantize # PocketAccount as class
    provider = account_class_name.underscore.split("_").first # pocket
    account = klass.find(account_id)

    #If we have the import job ready
    if self.respond_to? provider
      # Now we get the list of articles
      articles = self.send(provider, account)
    else
      puts "Import method missing for #{provider}"
      articles = []
    end

    # Now, insert all these articles using a single transaction
    ActiveRecord::Base.transaction do
      articles.each do |article|
        article = user.articles.create(
          :url=>article[:url],
          :provider=>provider,
          :title=>article[:title],
          :tags=>article[:tags],
          :content=>article[:content]
        )
        Resque.enqueue ExtractorJob, article.id unless article.id.nil?
      end
    end
  end

  # Fetch *all* content stored in pocket
  def self.pocket (account)
    # Setup
    articles = Array.new
    PocketApi.configure(:client_key=> Rails.application.secrets.pocket_key, :access_token => account.token)

    # Keep fetching articles till there are more
    offset = 0
    count = 100 # How many articles to fetch at once
    loop do
      result = PocketApi.retrieve(
        :state => 'all',
        :sort => 'oldest',
        :detailType => 'complete',
        :count=>count,
        :offset=>offset
      )
      # Insert article has into articles array
      result.each do |key, article|
        tags = article['tags'].map { |tag,fields| tag}.select { |tag| !tag.squish.empty? }.join ',' if article['tags']
        articles.push({
          :url=>    article['resolved_url'],
          :title=>  article['title'].presence || article['resolved_title'],
          :tags=>   tags.presence || '',
          :content=>article['excerpt']
        })
      end
      offset+=count
      break if result.empty? or result.count < count
    end
    # Return articles array
    articles
  end


  # Fetches all starred repos for a github account
  # Returns an array of Article hashes
  def self.github(account)
    # Setup
    articles = Array.new
    github = Octokit::Client.new(:access_token => account.token)
    Octokit.auto_paginate = true

    # Now we iterate
    github.starred.reverse.each do |repo|
      articles.push({
        :url=>repo.html_url,
        :title=>repo.full_name,
        :tags=>repo.language,
        :content => repo.description
      })
    end

    # Return articles array
    articles
  end
end