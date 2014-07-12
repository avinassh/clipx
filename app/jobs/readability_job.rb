class ReadabilityJob
  # TODO: Rename this job to ExtractorJob
  # as we may shift from readability in the future
  @queue = :readability
  def self.perform(article_id)
    puts "Running readability job"
    article = Article.find(article_id)
    article.update_attribute 'status', 'held'
    # TODO: This will be updated by readability once we have it working
    article.update_attribute 'heading', article.title
    Resque.enqueue PublishJob, article_id
  end
end