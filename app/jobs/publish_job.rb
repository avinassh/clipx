class PublishJob
  # This job calls various publish services
  @queue = :publish
  def self.perform(article_id)
    article = Article.find(article_id)
    publisher_accounts = article.user.publishers
    publisher_accounts.each do |account|
      # We get the class using account.publisher
      # and use that to publish the article
      account.publisher.publish account, article
    end
  end
end