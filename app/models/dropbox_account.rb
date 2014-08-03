class DropboxAccount < PublisherAccount

  validates_presence_of :email, :token, :uid

  # Creates a new (unsaved) dropbox account
  # Unattached to any user
  # Returns an instance of DropboxAccount
  def self.create_from_omniauth(omniauth)
    account = self.new

    # Create the account object
    account.token = omniauth.credentials.token
    account.email = omniauth.info.email
    account.uid = omniauth.uid

    # Return the account itself
    account
  end
end