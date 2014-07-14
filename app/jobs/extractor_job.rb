ReadabilityParser.api_token = Rails.application.secrets.readability_parser_key

class ExtractorJob
  @queue = :extractor
  def self.perform(article_id)
    puts "Running extractor job"
    article = Article.find(article_id)
    article.update_attribute 'status', 'held'
    
    webpage = ReadabilityParser.parse article.url
    
    article.update_attribute 'heading', webpage.title
    article.update_attribute 'content', webpage.content

    Resque.enqueue PublishJob, article_id
  end
end