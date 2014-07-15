class PocketAccount < AbstractAccount
  validates_presence_of :token, :username, :last_fetched
  # Remember to make sure that the initialize method is not
  # overridden in a method with default values
  # see http://blog.phusion.nl/2008/10/03/47/#Caveats for more details
  def self.create_from_omniauth(omniauth)
    account = self.new
    account.token = omniauth.credentials.token
    account.username = omniauth.uid
    account.last_fetched = Time.now.to_i
    account
  end
end
