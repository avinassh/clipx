class Article < ActiveRecord::Base
  validates_presence_of :url, :provider, :status, :user_id
  belongs_to :user

  def publish
    evernote_account = self.user.evernote_account
    evernote_client = EvernoteUtil.new evernote_account.notestore_url, evernote_account.token
    begin
      # TODO: Shift to heading once we have readability
      evernote_client.create_note self.title, self.content, evernote_account.notebook_guid
    rescue Evernote::EDAM::Error::EDAMNotFoundException => e
      # The notebook might have been deleted, so re-recreate it
      notebook = EvernoteUtil.create_notebook 'ClipX'
      # Update the guid in our table
      evernote_account.update_attribute 'notebook_guid', notebook.guid
      # retry publishing
      self.publish
    end
    self.update_attribute 'status', 'published'
  end
end