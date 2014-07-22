class PublisherAccount < AbstractAccount
  self.abstract_class = true
  def publisher
    # provider_name is like "evernote"
    provider_name = self.class.name.underscore.split("_")[0]
    # this is converted to a class like EvernotePublisher
    (provider_name+"_publisher").camelize.constantize
  end
end