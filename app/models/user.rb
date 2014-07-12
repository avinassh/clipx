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

    #Delete the current pocket account associated
    self.pocket_account.delete if self.pocket_account
    self.create_pocket_account ({:token=>token, :last_fetched=>Time.now.to_i, :username=>pocket_username})
  end

  def add_evernote_account(omniauth)
    
    #Get required variables from omniauth
    token = omniauth.credentials.token
    username = omniauth.info.nickname
    notestore_url = omniauth.extra.access_token.params['edam_noteStoreUrl']

    #Create or find a notebook with the given name
    evernote = EvernoteUtil.new notestore_url, token
    notebook_guid = evernote.find_or_create_notebook('ClipX').guid

    #Delete any existing evernote account connection
    self.evernote_account.delete if self.evernote_account
    self.create_evernote_account(
      :token=>token,
      :last_published=>Time.now.to_i,
      :username=>username,
      :notestore_url => notestore_url,
      :notebook_guid => notebook_guid
    )
  end

end
