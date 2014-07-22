class EvernoteAccount < PublisherAccount
  
  validates_presence_of :username, :token, :notestore_url, :notebook_guid

  # Creates a new (unsaved) evernote account
  # Unattached to any user
  # Returns an instance of EvernoteAccount
  def self.create_from_omniauth(omniauth)
    account = self.new

    # Get required variables from omniauth
    token = omniauth.credentials.token
    notestore_url = omniauth.extra.access_token.params['edam_noteStoreUrl']

    # Create the account object
    account.token = token
    account.last_published = Time.now.to_i
    account.username = omniauth.info.nickname
    account.notestore_url = notestore_url
    account.notebook_guid = account.fetch_notebook

    # Return the account itself
    account
  end

  # Create or find a notebook with the given name
  # Returns the notebook guid as a string
  def fetch_notebook
    evernote = EvernoteUtil.new self.notestore_url, self.token
    evernote.find_or_create_notebook('ClipX').guid
  end

  def publisher
    EvernotePublisher
  end
end