require 'octokit'

class FetchGithubJob
  @queue = :fetch
  def self.perform(github_account_id)

    account = GithubAccount.find(github_account_id)

    # Save the time when we are making the request
    current_time = Time.now.to_i
    user = account.user

    github = Octokit::Client.new(:access_token => account.token)

    github.starred.each do |repo|
      url = repo.html_url
      begin
        article = user.articles.create!(
          :url=>url,
          :title=>repo.full_name,
          :provider=>'github',
          :tags=>repo.language,
          :content => repo.description
        )
        Resque.enqueue ExtractorJob, article.id unless article.id.nil?
      rescue ActiveRecord::RecordInvalid
        # We quit if we find an existing record
        break
      end
    end
    # Update the account in our db
    account.update_attribute :last_fetched, current_time
  end
end