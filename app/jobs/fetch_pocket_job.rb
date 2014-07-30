require 'pocket_api'
class FetchPocketJob
  @queue = :fetch
  def self.perform(pocket_account_id)

    account = PocketAccount.find(pocket_account_id)

    # Save the time when we are making the request
    current_time = Time.now.to_i
    user = account.user

    # Make the reqest
    PocketApi.configure(:client_key=> Rails.application.secrets.pocket_key, :access_token => account.token)
    result = PocketApi.retrieve(
      :state => 'all',
      :contentType => 'article',
      :sort => 'newest',
      :detailType => 'complete',
      :since => account.last_fetched,
      :count=>10
    )

    # Iterate over the result and insert to db
    result.each do |key, a|
      puts a['resolved_url']
      tags = a['tags'].map { |tag,fields| tag}.join ',' if a['tags']
      begin
        article = user.articles.create!(
          :url=>a['resolved_url'],
          :title=>a['given_title'],
          :provider=>'pocket',
          :tags=>tags,
          #TODO: Check for any images that pocket gave us
          :content => a['excerpt']
        )
        Resque.enqueue ExtractorJob, article.id unless article.id.nil?

      # Catching any non-unique entry error. Uniqueness check in user_id + url
      rescue ActiveRecord::RecordInvalid
        puts 'Not unique'
      end
    end

    puts "#{result.size} articles fetched"
    # Update the account in our db
    account.update_attribute :last_fetched, current_time
  end
end