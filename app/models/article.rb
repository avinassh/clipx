class Article < ActiveRecord::Base
  validates_presence_of :url, :provider, :status, :user_id
  validates_uniqueness_of :url, :scope => [:user_id, :url]
  belongs_to :user

  def publish
    evernote_account = self.user.evernote_account
    evernote_client = EvernoteUtil.new evernote_account.notestore_url, evernote_account.token
    begin
      # tags might be nil, if not split by comma
      tags = self.tags ? self.tags.split(',') : Array.new
      title = self.title.squish.empty?  ? self.heading : self.title
      evernote_client.create_note title, self.content, evernote_account.notebook_guid, tags, self.url, self.provider
    rescue Evernote::EDAM::Error::EDAMNotFoundException => e
      # The notebook might have been deleted, so re-recreate it
      notebook = evernote_client.find_or_create_notebook 'ClipX'
      # Update the guid in our table
      evernote_account.update_attribute 'notebook_guid', notebook.guid
      # retry publishing
      self.publish
    end
    self.update_attribute 'status', 'published'
  end
end
