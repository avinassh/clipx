require 'ostruct'
require 'base64'

ReadabilityParser.api_token = Rails.application.secrets.readability_parser_key

class ExtractorJob
  @queue = :extractor
  def self.perform(article_id)
    article = Article.find(article_id)
    article.update_attribute 'status', 'held'

    if article.provider == 'github'
      webpage = self.github article
    else
      webpage = ReadabilityParser.parse article
    end

    article.update_attribute 'heading', webpage.title
    article.update_attribute 'content', webpage.content

    Resque.enqueue PublishJob, article_id
  end

  def self.github(article)
    client = Octokit::Client.new(:access_token => article.user.github_account.token)

    # Convert the url to user+repo
    url = article.url.split("/")
    username = url[url.length-2]
    reponame = url[url.length-1]

    html = client.readme "#{username}/#{reponame}", :accept => 'application/vnd.github.html'

    OpenStruct.new({
      :content => html,
      :title => "#{username}/#{reponame}"
    })
  end
end