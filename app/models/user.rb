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
    token = omniauth.credentials.token
    username = omniauth.info.nickname
    notestore_url = omniauth.extra.access_token.params.edam_noteStoreUrl
    self.evernote_account.delete if self.evernote_account
    self.create_evernote_account ({:token=>token, :last_published=>Time.now.to_i, :username=>username})
  end

end
