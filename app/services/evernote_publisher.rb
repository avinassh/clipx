class EvernotePublisher < PublisherService
  def publish (account, article)
    evernote_client = EvernoteUtil.new account.notestore_url, account.token
    begin
      # tags might be nil, if not split by comma
      tags = article.tags ? article.tags.split(',') : Array.new
      title = article.title_or_heading
      evernote_client.create_note title, article.content, account.notebook_guid, tags, article.url, article.provider
    rescue Evernote::EDAM::Error::EDAMNotFoundException => e
      # The notebook might have been deleted, so re-recreate it
      notebook = evernote_client.find_or_create_notebook 'ClipX'
      # Update the guid in our table
      account.update_attribute 'notebook_guid', notebook.guid
      # retry publishing
      article.publish
    end
    article.mark_as_published("evernote")
  end

  def export(account)
    account.user.articles.find_each do |article|
      self.publish account, article
    end
  end
end