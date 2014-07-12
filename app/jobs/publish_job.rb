class PublishJob
  # This job calls various publish services
  @queue = :publish
  def self.perform(article_id)
    # TODO: Publisher class structure
    puts "Running publish job"
    article = Article.find(article_id)
    article.publish
  end
end