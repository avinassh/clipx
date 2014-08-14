class GithubAccount < AbstractAccount
  cattr_accessor :fetcher_name
  @@fetcher_name = 'GitHub'
  validates_presence_of :uid, :username, :token
  # Remember to make sure that the initialize method is not
  # overridden in a method with default values
  # see http://blog.phusion.nl/2008/10/03/47/#Caveats for more details
  def self.create_from_omniauth(omniauth)
    account = self.new
    account.token = omniauth.credentials.token
    account.uid = omniauth.uid
    account.username = omniauth.info.nickname
    account
  end
end
