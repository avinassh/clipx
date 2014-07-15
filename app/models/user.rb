class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:pocket, :evernote]
  has_one :pocket_account
  has_one :evernote_account
  has_many :articles

  def add_pocket_account(omniauth)
    token = omniauth.credentials.token
    pocket_username = omniauth.uid

    # Delete the current pocket account associated
    self.pocket_account.delete if self.pocket_account
    self.create_pocket_account ({:token=>token, :last_fetched=>Time.now.to_i, :username=>pocket_username})
  end

  def add_evernote_account(omniauth)
    
    # Get required variables from omniauth
    token = omniauth.credentials.token
    username = omniauth.info.nickname
    notestore_url = omniauth.extra.access_token.params['edam_noteStoreUrl']

    # Create or find a notebook with the given name
    evernote = EvernoteUtil.new notestore_url, token
    notebook_guid = evernote.find_or_create_notebook('ClipX').guid

    # Delete any existing evernote account connection
    self.evernote_account.delete if self.evernote_account
    self.create_evernote_account(
      :token=>token,
      :last_published=>Time.now.to_i,
      :username=>username,
      :notestore_url => notestore_url,
      :notebook_guid => notebook_guid
    )
  end

  def admin?
    self.email == Rails.application.secrets.admin_email
  end

  # Returns all integrated accounts available to the user
  # type - Class to filter this account list against
  #        You may so far pass only PublisherAccount to this option 
  def accounts(type=AbstractAccount)
    # See http://stackoverflow.com/questions/3371518/in-ruby-is-there-an-array-method-that-combines-select-and-map/17703276#17703276
    # for why reduce was used here
    self.class.reflect_on_all_associations(:has_one).reduce([]) do |result, association|
      result.push self.send association.name if association.klass < type
      result
    end
  end

  # Returns all PublisherAccounts belonging to the user
  def publishers
    self.accounts PublisherAccount
  end
end
