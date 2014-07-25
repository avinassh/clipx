require 'twitter'
class FetchTwitterJob
  @queue = :fetch
  def self.perform(twitter_account_id)

    account = TwitterAccount.find(twitter_account_id)

    # Save the time when we are making the request
    current_time = Time.now.to_i
    user = account.user

    # Create a new twitter client
    config = {
      :consumer_key    => Rails.application.secrets.twitter_key,
      :consumer_secret => Rails.application.secrets.twitter_secret,
      :access_token    => account.token,
      :access_token_secret => account.secret
    }
    twitter = Twitter::REST::Client.new(config)

    favorites = nil
    if account.last_fetched_id
      favorites = twitter.favorites :since_id =>account.last_fetched_id
    else
      favorites = twitter.favorites
    end
    favorites.each do |tweet|
      if tweet.urls?
        tweet.urls.each do |link|

          tags = tweet.hashtags if tweet.hashtags?
          if tags
            puts tags
            tags = tags.map &:text
          else
            tags = []
          end

          begin
            article = user.articles.create!(
              :url=>link.expanded_url.to_s,
              # We put a blank title, so everything uses heading internally
              :title=>"",
              :provider=>'twitter',
              :content => tweet.text,
              :tags=>tags.join(",")
            )
            Resque.enqueue ExtractorJob, article.id unless article.id.nil?
          rescue ActiveRecord::RecordInvalid
            puts "Link already added"
          end
        end
      end
    end

    # Update the account in our db
    account.update_attribute :last_fetched, current_time
    account.update_attribute :last_fetched_id, favorites.first.id
  end
end