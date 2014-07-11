class ReadabilityJob
  @queue = :readability
  def self.perform(article_id)
    Article.find(article_id).update_attribute 'status', 'held'
  end
end