class ReadabilityJob
  #TODO: Rename this job to ExtractorJob
  #as we may shift from readability in the future
  @queue = :readability
  def self.perform(article_id)
    puts "Running readability job"
    Article.find(article_id).update_attribute 'status', 'held'
    Resque.enqueue PublishJob, article_id
  end
end