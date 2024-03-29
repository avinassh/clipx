class GoogleAccount < PublisherAccount

  validates_presence_of :email, :token, :refresh_token, :token_expiry

  # Creates a new (unsaved) google account
  # Unattached to any user
  # Returns an instance of GoogleAccount
  def self.create_from_omniauth(omniauth)
    account = self.new

    # Create the account object
    account.token = omniauth.credentials.token
    account.token_expiry = omniauth.credentials.expires_at
    account.refresh_token = omniauth.credentials.refresh_token
    account.email = omniauth.info.email

    # Return the account itself
    account.spreadsheet_id = account.fetch_spreadsheet("ClipX Bookmarks", "All your bookmarks synced from ClipX")
    account
  end

  # Create or find a spreadsheet with the given title
  # Returns spreadsheet URL
  def fetch_spreadsheet(title, description)
    spreadsheet = GoogleUtil.new(self).find_or_create_spreadsheet(title, description)
    spreadsheet['id']
  end
end