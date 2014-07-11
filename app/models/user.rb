class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:pocket]
  has_one :pocket_account
  has_many :article

  def add_pocket_account(omniauth)
    token = omniauth.credentials.token
    pocket_username = omniauth.uid

    #Delete the current pocket account associated
    self.pocket_account.delete if self.pocket_account
    self.create_pocket_account ({:token=>token, :last_fetched=>Time.now.to_i, :username=>pocket_username})
  end

end
